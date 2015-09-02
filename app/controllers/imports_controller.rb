#require 'spreadsheet'

class ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy]

  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
  end

  # GET /imports/1
  # GET /imports/1.json
  def show
  end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit
  end

  # POST /imports
  # POST /imports.json
  def create
    @import = Import.new(import_params)
    uploaded_io = params[:import][:filename]
    #puts "Uploaded file #{uploaded_io.original_filename}"
    filepath = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    @import.filename = filepath
    @import.content_type = uploaded_io.content_type
    if @import.content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      book = RubyXL::Parser.parse filepath
      #book.worksheets.each do |w|
        #puts w.name
      #end
      master = book['Master']
      minutes = book['Minutes']
      
      #
      # Process the MASTER tab
      #

      # Read the second row, containing the meeting names, and create Meeting objects for them.
      # Associate the column numbers with the Meeting objects.
      meetings = []
      meetnamerow = master[1]
      meetnamerow[(i=6)..meetnamerow.size-1].each do |mtgcell|
        mtgname = mtgcell.value
        break unless (not mtgname.nil?) and (mtgname.length > 1)
        #meeting = Meeting.new
        titlewords = mtgname.split("\s")
        #byebug
        meetingdate = "1 " + titlewords[0] + " " + titlewords[1]
        meeting = Meeting.where(:date => meetingdate).first_or_create do |m|
          m.date = meetingdate
          m.meetingtype = titlewords[2]
        end
        meetings[i] = { :name => mtgname, :mtg => meeting }
        i += 1
      end

      #byebug
      # Read each row of the MASTER tab starting at the third row.  Identify rows with a valid item number
      # and create Items for each.
      i = 0
      #puts "There are #{master.rows.count} rows altogether"
      master.to_a[2..-1].each do |itemrow|  # the 2 says skip the first two rows.
        i += 1
        next unless itemrow[0].value =~ /\d\d\d\d/
        item = Item.new
        item.number = itemrow[0].value
        day,month,year = itemrow[1].value.split('-')
        year = year.to_i
        year = year + 2000 if year < 100
        item.date = day.to_s + month.to_s + year.to_s
        item.standard = itemrow[2].value
        item.clause = itemrow[3].value
        item.subject = itemrow[4].value
        item.draft = itemrow[5].value

        # Iterate over the columns (starting at the 7th) in the row and create a Minute entry per column.
        # Record the status and the Meeting in the minutes entry.  
        itemrow[(j=6)..itemrow.cells.count-1].each do |stscell|
          j += 1
          sts = stscell.value
          next if sts == "-"
          break if sts == "#"
          #byebug
          min = item.minutes.new
          min.status = sts
          min.meetings << meetings[j-1][:mtg]
        end

        item.save
        #break if i > 5
      end

      #
      # Process the MINUTES tab
      #

      # Rows in the MINUTES tab come in sets of three, starting with the second row in the tab.
      # 1. Contains the item number and for each meeting, the date of the minutes entry.
      # 2. For each meeting, contains the text of the minutes.
      # 3. Contains nothing of use.
      rowno = 1
      while (inum = minutes[rowno][1].value) =~ /\d\d\d\d/
        item = Item.where(:number => inum).first
        die if item.nil?
        datesrow = minutes[rowno]
        textrow  = minutes[rowno+1]
        j = 3
        while j < datesrow.cells.count do
          if datesrow[j].nil? or minutes[0][j].nil?
            j += 1
            next
          end
          mindate = datesrow[j].value
          #puts "Minute date #{mindate}"
          mtgtitle = minutes[0][j].value
          mtgtitlebits = mtgtitle.split(": ")
          #puts "Meeting title date X#{mtgtitlebits[1]}X"
          month,year = mtgtitlebits[1].split("-")
          year = year.to_i
          year = year + 2000 if year < 100
          date = (year.to_s + "-" + month + "-01").to_date
          #puts "Meeting title converted date #{date}"
          min = item.minutes.joins(:meetings).where("meetings.date = ?", date).first
          if min.nil?
            j += 1
            next
          else
            min.date = mindate
            min.text = textrow[j].value unless textrow[j].nil?
            #puts "#{min.inspect}"
            min.save
          end
          j += 1
        end
        rowno += 3
        #break if rowno > 8
      end

      # Annoyingly, we have to go through all the items and save them, so that the latest_status gets updated.
      Item.all.each do |it|
        it.save
      end
      @import.imported = true
    else
      @import.errors.add(:imports, "must be an Excel spreadsheet (not #{@import.content_type})")
      flash[:error] = @import.errors.full_messages.to_sentence
      puts "#{filepath}: not an Excel spreadsheet (#{@import.content_type})"
    end


    respond_to do |format|
      if @import.errors.count == 0 and @import.save
        format.html { redirect_to @import, notice: 'File was successfully imported.' }
        format.json { render :show, status: :created, location: @import }
      else
        format.html { render :new }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /imports/1
  # PATCH/PUT /imports/1.json
  def update
    fname = @import.filename
    bs,_,ext = fname.rpartition(".")
    outfname = bs + "-out." + ext
    #byebug

    book = RubyXL::Parser.parse(fname)
    master = book['Master']
    minutes = book['Minutes']
    meetnamerow = master[1]
    col = 6

    Meeting.order(:date).each do |mtg|
      #byebug
      raise SyntaxError, "Missing prepared column in Master column, row 2, column #{col}" if master[2][col].nil? or master[2][col].value.nil?
      if meetnamerow[col].nil? or meetnamerow[col].value.nil? or meetnamerow[col].value.length <= 1
        meetnamerow[col].change_contents(mtg.date.strftime("%B %Y ") + mtg.meetingtype + " Meeting")
        meetnamerow[col].style_index = meetnamerow[col-1].style_index # copy previous cell's style
        #byebug
      end
      col += 1
    end
    # Put actual code here.

    book.write(outfname)

    respond_to do |format|
      format.html {
        # redirect_to @import, notice: 'Import was successfully updated.'
        response.headers["Content-Length"] = File.size(outfname).to_s
        send_file(outfname, type: @import.content_type, x_sendfile: true)
        return
      }
      format.json { render :show, status: :ok, location: @import }
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: 'Import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_import
      @import = Import.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def import_params
      params.require(:import).permit(:filename, :imported)
    end
end
