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

  # Update method: this is what I am using for Export of the database into a previously imported XLSX file.
  # I recognise that this is a bit of a perversion of the real meaning of UPDATE.
  # The originally imported file is re-read from disk into a RubyXL model, and that model is then updated using the
  # information in the Rails database.  Then, the file is sent to the browser (downloaded, with a modified filename) for
  # progression into the old spreadsheet-based Maintenance process.  The structure of the uploaded file must be complete
  # and provide room for expansion. That is, there must already be pre-populated columns for new meetings, and rows for
  # new maintenance items.  This is because this program does not change the structure of the file or add new formulae
  # anywhere - it just writes values into the Master and Minutes tabs in the appropriate places.
  # Is it best to just patch a few values into the spreadsheet where they are known to have changed, or is it best to rewrite
  # all the values in big blocks of the spreadsheet?  The former seems more conservative, but the latter would be more likely
  # to ensure consistency.

  # The Masters sheet has no formulae, just manually entered data and # signs to populate unused cells

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

    ##
    ## Write out meeting names onto Master sheet
    ##
    # Old algorithm: In the Master sheet of the imported spreadsheet, check the row containing meeting names.  Count them off against
    # a list of meetings taken from the database.  If there are any extras at the end of the database's list, change cells in
    # the spreadsheet to incorporate additional meetings.
    # New algorithm: just write the meeting names of the meetings into the spreadsheet, and never mind what was there before.
    # Copy the style settings (e.g., rotate text up) from the previous cell.
    meetnamerow = master[1]
    col = 6
    mtgcols = {}

    Meeting.order(:date).each do |mtg|
      @import.errors.add(:import, "Master sheet doesn't have enough meeting columns: cell #{RubyXL::Reference.ind2ref(2,col)} is blank") if master[2][col].nil? or master[2][col].value.nil?
      mtgcols[mtg.id] = col          # Associate meeting IDs with column numbers, for use when writing status entries per Item below.
      mtgname = mtg.date.strftime("%B %Y ") + mtg.meetingtype + " Meeting"
      if meetnamerow[col].nil?
        master.add_cell(1, col, mtgname)
      else
        meetnamerow[col].change_contents(mtgname)
      end
      meetnamerow[col].style_index = meetnamerow[col-1].style_index if col>6 # copy previous cell's style
      col += 1
    end

    # Dates: 
    # dt = Date.parse("January 20, 2011")
    # cell.change_contents(dt.strftime("%d-%b-%y"))
    # cell.set_number_format("d-mmm-yy")
    # cell.is_date? is still false :( but never mind.
    # When written out to an .xlsx file, that cell looks like a date in Excel and calculates like a date.

    def chg_or_create_cell(sheet,row,col,value,numfmt = nil)
      sheet.insert_row(row) if sheet[row].nil?
      if sheet[row][col].nil?
        sheet.add_cell(row, col, value)
      else
        sheet[row][col].change_contents(value) unless sheet[row][col].value == value
      end
      sheet[row][col].set_number_format(numfmt) unless numfmt.nil?
      sheet[row][col]
    end

    ##
    ## Write out each item onto a row
    ##
    # Order the Items in the database by number. For each item, write a row.
    rowno = 2
    Item.order(:number).each do |item|
      chg_or_create_cell(master, rowno, 0, item.number.to_s)
      chg_or_create_cell(master, rowno, 1, item.date.strftime("%-d-%b-%y"), "d-mmm-yy")
      chg_or_create_cell(master, rowno, 2, item.standard)
      chg_or_create_cell(master, rowno, 3, item.clause)
      chg_or_create_cell(master, rowno, 4, item.subject)
      chg_or_create_cell(master, rowno, 5, item.draft)
      ordd = item.minutes.joins(:meetings).order("meetings.DATE")
      firstcol = mtgcols[ordd.first.meetings.first.id]
      (6..firstcol).each do |unusedcol|
        chg_or_create_cell(master, rowno, unusedcol, "-")
      end
      ordd.each do |min|
        chg_or_create_cell(master, rowno, mtgcols[min.meetings.first.id], min.status) unless min.meetings.first.nil?
      end
      rowno += 1
    end
    # byebug
    # Blank out the remaining rows, in case we deleted an item
    (rowno..(master.count-1)).each do |unusedrow|
      [0,2,3,4,5].each do |coltoblank|
        master[unusedrow][coltoblank].change_contents(nil)
      end
      master[unusedrow][1].change_contents('#') unless master[unusedrow][1].value == '#'
      (6..(master[unusedrow].size-1)).each do |coltohash|
        next if master[unusedrow][coltohash].nil?
        master[unusedrow][coltohash].change_contents('#') unless master[unusedrow][coltohash].value == '#'
      end
    end

    # State of play: Master sheet writes out quite nicely.  But new meetings don't have copies of the previous meeting's status
    # entries in their column, so that needs to be added somehow, even where there's no minute for that meeting.
    # Once that's done then the Minutes tab needs to be written out.

    # Put actual code here.

    book.write(outfname)

    respond_to do |format|
      if @import.errors.count == 0 
        format.html {
          # redirect_to @import, notice: 'Import was successfully updated.'
          response.headers["Content-Length"] = File.size(outfname).to_s
          send_file(outfname, type: @import.content_type, x_sendfile: true)
          return
        }
        format.json { render :show, status: :ok, location: @import }
      else
        format.html { render :edit }
        format.json { render json: @import.errors, status: :unprocessable_entity }
      end
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
