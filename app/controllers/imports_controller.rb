#require 'spreadsheet'

class ImportsController < ApplicationController
  load_and_authorize_resource
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
    unless params[:import].present?
      flash[:error] = "A file must be selected for upload."
      redirect_to imports_path
      return
    end
    if params[:replace].present?
      Minute.destroy_all
      Item.destroy_all
      Meeting.destroy_all
      Import.destroy_all
    end
    Rails.application.config.importing = true   # Supress validation checks for Minutes during import.
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
      meetnamerow[(j=6)..meetnamerow.size-1].each do |mtgcell|
        mtgname = mtgcell.value
        break if mtgname.nil? or mtgname.length <= 1 or mtgname.blank?
        # Date.parse will parse a date from the start of the string.  If of the form "Mar 2013 interim" the date will be 2013-03-01.
        meetingdate = Date.parse(mtgname)
        meeting = Meeting.find_or_create_by(date: meetingdate) do |m|
          m.date = meetingdate
          # Pick one of these words as the meeting type if present
          mtgtype = mtgname.match(/[iI]nterim|[Pp]lenary|[tT]elecon\w*|[cC]on\w*|[cC]all/)
          m.meetingtype = mtgtype && mtgtype[0].capitalize
          # Otherwise, go for the word after the word containing the year
          if mtgtype.nil?
            words = mtgname.split("\s")
            pos = words.index { |word| word =~ /\d{4}/ }
            if pos
              word = words[pos+1]
              m.meetingtype = word.capitalize if word
            end
          end
        end
        meetings[j] = { :name => mtgname, :mtg => meeting }
        j += 1
      end

      # Read each row of the MASTER tab starting at the third row.  Identify rows with a valid item number
      # and create (or find) Items for each.
      i = 0
      master.to_a[2..-1].each do |itemrow|  # the 2 says skip the first two rows.
        i += 1
        next unless itemrow[0].value =~ /\d\d\d\d/
        item = Item.find_or_create_by!(number: itemrow[0].value) do |it|
          it.number = itemrow[0].value
          it.date = Date.parse(itemrow[1].value)
          it.standard = itemrow[2].value
          it.clause = itemrow[3].value
          it.subject = itemrow[4].value
          it.draft = itemrow[5].value
        end

        # Iterate over the columns (starting at the 7th) in the row and create a Minute entry per column.
        # Record the status and the Meeting in the minutes entry.  
        itemrow[(j=6)..itemrow.cells.count-1].each do |stscell|
          j += 1
          sts = stscell.value
          next if sts == "-"
          break if sts == "#"
          min = item.minutes.find_or_initialize_by(meeting_id: meetings[j-1][:mtg].id) do |m|
            m.status = sts
            m.meeting = meetings[j-1][:mtg]
          end
          #byebug
          item.minutes << min if min.new_record?
          unless min.save
            min.errors.full_messages.each do |e|
              puts e
            end
            raise "Can't save minute"
          end
        end

        unless item.save
          item.errors.full_messages.each do |e|
            puts e
          end
          raise "Can't save item"
        end
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
        raise "Missing entry on Master sheet for item #{inum} from Minutes tab" if item.nil?
        datesrow = minutes[rowno]
        textrow  = minutes[rowno+1]
        j = 3
        while j < datesrow.cells.count do
          if datesrow[j].nil? or minutes[0][j].nil?
            j += 1
            next
          end
          mindate = datesrow[j].value
          # If there's no existing minute entry but the spreadsheet has one, we create one
          # This logic seems tortuous - there must be a better way to do it.
          min = item.minutes.where(meeting_id: meetings[j+3][:mtg].id).first
          changed = false
          if min.nil? and (not mindate.blank? or not (textrow[j].nil? or textrow[j].value.blank?))
            min = item.minutes.create(meeting: meetings[j+3][:mtg])
            changed = true
          end
          if not mindate.blank? and min.date.blank?
              min.date = mindate
              changed = true
          end
          if (not (textrow[j].nil? or textrow[j].value.blank?)) and min.text.blank?
              min.text = textrow[j].value
              changed = true
          end

          if changed and not min.save
            min.errors.full_messages.each do |e|
              puts e
            end
            raise "Can't save minute"
          end
          # If there's an existing minute entry, we don't change it even if the spreadsheet has no entry. 
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
    Rails.application.config.importing = false


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

    book = RubyXL::Parser.parse(fname)
    master = book['Master']
    minutes = book['Minutes']
    
    # Write out the meeting names unconditionally into Excel row 2 of the Master tab
    meetnamerow = master[1]
    col = 6
    Meeting.order(:date).each do |mtg|
      raise SyntaxError, "Missing prepared column in Master sheet, row 2, column #{col+1}" if master[2][col].nil? or master[2][col].value.blank?
      # Overwrite existing information with the information from the database
      if mtg.date.day == 1
        fmt = "%B %Y "
      else
        fmt = "%-d %B %Y "
      end
      meetnamerow[col].chgifnecessary(mtg.date.strftime(fmt) + mtg.meetingtype + " Meeting")
      meetnamerow[col].style_index = meetnamerow[col-1].style_index if col>6 # copy previous cell's style
      col += 1
    end

    # Go through the database Items in numerical order:
    # 1. In a row on the Master sheet, write out the item's properties and then its per-meeting statuses.
    #    Handle missing meeting statuses including at the end of the line.
    #    Note: With the current release of RubyXL (3.3.12), there's nothing we can do about the hyperlinks.  They are properties
    #          of the sheet, not the cell.
    #          RubyXL::Reference.ref2ind(master.hyperlinks.first.ref.to_s)
    #          master.relationship_container.find_by_rid(master.hyperlinks.first.r_id)
    # 2. Write three rows on the Minutes sheet.
    rowno = 2
    Item.order(:number).each do |item|
      row = master[rowno]
      # Change_contents spoils the shared string thing, so don't write unless you have to.
      row[0].chgifnecessary(item.number)
      row[1].chgifnecessary(item.date.strftime("%-d-%b-%y"))
      row[2].chgifnecessary(item.standard)
      row[3].chgifnecessary(item.clause)
      row[4].chgifnecessary(item.subject)
      row[5].chgifnecessary(item.draft)
      # There may not be a minutes entry corresponding to each meeting (=column), so keep a track of the item's current status
      # and use that where no minutes entry exists.
      current_sts = "-"
      colno = 6
      Meeting.order(:date).each do |mtg|
        min = item.minutes.where("minutes.meeting_id = ?", mtg.id).first
        current_sts = min.status if min
        raise SyntaxError, "Missing prepared column in Master sheet, row #{rowno+1}, column #{colno+1}" if row[colno].nil? or row[colno].blank?
        row[colno].chgifnecessary(current_sts)
        colno += 1
      end
      rowno += 1
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
