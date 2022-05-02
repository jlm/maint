# frozen_string_literal: true

# rubocop:disable Style/Documentation, Metrics/ClassLength

class ImportsController < ApplicationController
  # rubocop:enable Style/Documentation

  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_import, only: %i[show edit update destroy]

  # GET /imports
  # GET /imports.json
  def index
    @imports = Import.all
  end

  # GET /imports/1
  # GET /imports/1.json
  def show; end

  # GET /imports/new
  def new
    @import = Import.new
  end

  # GET /imports/1/edit
  def edit; end

  # POST /imports
  # POST /imports.json
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity

  def create
    unless params[:import].present?
      flash[:error] = 'A file must be selected for upload'
      redirect_to imports_path
      return
    end
    if params[:replace].present?
      Minute.destroy_all
      Request.destroy_all
      Item.destroy_all
      Meeting.destroy_all
      Import.destroy_all
      Minst.destroy_all #   NOTE: initial values are seeded. Reading from a spreadsheet replaces these.
    end
    Rails.application.config.importing = true # Supress validation checks for Minutes during import.
    @import = Import.new(import_params)
    uploaded_io = params[:import][:filename]
    filepath = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    @import.filename = filepath
    @import.content_type = uploaded_io.content_type
    if @import.content_type == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      book = RubyXL::Parser.parse filepath
      totals = book['Totals']
      master = book['Master']
      minutes = book['Minutes']

      #
      # Import from the TOTALS tab
      #

      # Read columns B and D, where column C is a hyphen, to populate the possible Status values
      # of minutes (stored in minst_id) and items (stored in ??).
      totals.each do |totalsrow|
        next unless totalsrow && totalsrow[2] && totalsrow[2].value == '-'
        next unless totalsrow[1] && !totalsrow[1].value.blank?
        next unless totalsrow[3] && !totalsrow[3].value.blank?

        Minst.find_or_create_by(code: totalsrow[1].value) do |m|
          m.name = totalsrow[3].value.gsub(/<[bB][rR]>/, ' ')
        end
      end

      #
      # Import from the MASTER tab
      #

      # Read the second row, containing the meeting names, and create Meeting objects for them.
      # Associate the column numbers with the Meeting objects.
      meetings = []
      meetnamerow = master[1]
      meetnamerow[(j = 6)..meetnamerow.cells.count - 1].each do |mtgcell|
        mtgname = mtgcell.value
        break if mtgname.nil? || mtgname.length <= 1 || mtgname.blank?

        # Date.parse will parse a date from the start of the string.
        # If of the form "Mar 2013 interim" the date will be 2013-03-01.
        # rubocop:disable Metrics/BlockNesting

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
              word = words[pos + 1]
              m.meetingtype = word.capitalize if word
            end
          end
        end
        meetings[j] = { name: mtgname, mtg: meeting }
        j += 1
      end

      # Read each row of the MASTER tab starting at the third row.  Identify rows with a valid item number
      # and create (or find) Items for each.
      i = 0
      # rubocop:disable Metrics/BlockLength

      master.to_a[2..].each do |itemrow| # the 2 says skip the first two rows.
        i += 1
        next unless itemrow[0] && itemrow[0].value =~ /\d\d\d\d/

        #   NOTE: the items inside the "do" will not be updated on a merge import.
        item = Item.find_or_create_by!(number: itemrow[0].value) do |it|
          it.number = itemrow[0].value
          it.date = Date.parse(itemrow[1].value)
          it.standard = itemrow[2].value
          it.clause = itemrow[3].value
        end
        # These fields should be updated on a merge input.
        # They aren't part of the original Maintenance Request, and may have changed.
        item.subject = itemrow[4].value
        item.draft = itemrow[5].value

        # Iterate over the columns (starting at the 7th) in the row and create a Minute entry per column.
        # Record the status and the Meeting in the minutes entry.
        itemrow[(j = 6)..itemrow.cells.count - 1].each do |stscell|
          j += 1
          next if stscell.nil?

          sts = stscell.value
          next if sts == '-'

          break if sts == '#'

          if meetings[j - 1].nil?
            ref = RubyXL::Reference.ind2ref(stscell.row, stscell.column)
            raise SyntaxError, "No meeting exists in Master tab corresponding to status entry #{sts} in #{ref}"
          end

          min = item.minutes.find_or_initialize_by(meeting_id: meetings[j - 1][:mtg].id) do |m|
            m.minst = Minst.where(code: sts).first
            m.meeting = meetings[j - 1][:mtg]
          end
          item.minutes << min if min.new_record?
          next if min.save

          min.errors.full_messages.each do |e|
            puts e
          end
          raise "Can't save minute"
        end

        next if item.save

        item.errors.full_messages.each do |e|
          puts e
        end
        raise "Can't save item"
      end

      #
      # Import from the MINUTES tab
      #

      # Rows in the MINUTES tab come in sets of three, starting with the second row in the tab.
      # 1. Contains the item number and for each meeting, the date of the minutes entry.
      # 2. For each meeting, contains the text of the minutes.
      # 3. Contains nothing of use.
      rowno = 1
      while (inum = minutes[rowno][1].value) =~ /\d\d\d\d/
        item = Item.where(number: inum).first
        raise "Missing entry on Master sheet for item #{inum} from Minutes tab" if item.nil?

        datesrow = minutes[rowno]
        textrow  = minutes[rowno + 1]
        j = 3
        while j < [datesrow.cells.count, textrow.cells.count].max
          mindate = datesrow[j]&.value
          # If there's no existing minute entry but the spreadsheet has one, we create one
          # This logic seems tortuous - there must be a better way to do it.
          if meetings[j + 3].nil?
            ref = RubyXL::Reference.ind2ref(rowno, j)
            raise SyntaxError, "No meeting exists on Master tab corresponding to cell #{ref} on Minutes tab"
          end

          min = item.minutes.where(meeting_id: meetings[j + 3][:mtg].id).first
          changed = false
          if min.nil? && (!mindate.blank? || !(textrow[j].nil? || textrow[j].value.blank?))
            min = item.minutes.create(meeting: meetings[j + 3][:mtg])
            changed = true
          end
          if !mindate.blank? && min.date.blank?
            min.date = mindate
            changed = true
          end
          if !(textrow[j].nil? || textrow[j].value.blank?) && min.text.blank?
            min.text = textrow[j].value
            min.date = meetings[j + 3][:mtg].date if min.date.blank? && !min.text.blank?
            changed = true
          end

          if changed && !min.save
            min.errors.full_messages.each do |e|
              puts e
            end
            raise "Can't save minute"
          end
          # If there's an existing minute entry, we don't change it even if the spreadsheet has no entry.
          j += 1
        end
        rowno += 3
      end

      # Annoyingly, we have to go through all the items and save them, so that the minsts gets updated.
      Item.all.each(&:save)
      @import.imported = true
    else
      @import.errors.add(:imports, "must be an Excel spreadsheet (not #{@import.content_type})")
      flash[:error] = @import.errors.full_messages.to_sentence
      puts "#{filepath}: not an Excel spreadsheet (#{@import.content_type})"
    end
    Rails.application.config.importing = false

    respond_to do |format|
      if @import.errors.count.zero? && @import.save
        format.html { redirect_to imports_url, notice: 'File was successfully imported' }
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
    bs, _, ext = fname.rpartition('.')
    outfname = "#{bs}-out.#{ext}"

    book = RubyXL::Parser.parse(fname)
    master = book['Master']

    # Write out the meeting names unconditionally into Excel row 2 of the Master tab
    meetnamerow = master[1]
    col = 6
    Meeting.order(:date).each do |mtg|
      if master[2].nil? || master[2][col].nil? || master[2][col].value.blank?
        flash[:error] =
          "Missing prepared column in Master sheet, row 3, column #{col + 1}"
      end
      # Overwrite existing information with the information from the database
      fmt = if mtg.date.day == 1
              '%B %Y '
            else
              '%-d %B %Y '
            end
      master.add_or_chg(1, col, "#{mtg.date.strftime(fmt)}#{mtg.meetingtype} Meeting")
      meetnamerow[col].style_index = meetnamerow[col - 1].style_index if col > 6 # copy previous cell's style
      col += 1
    end

    # Go through the database Items in numerical order:
    # 1. In a row on the Master sheet, write out the item's properties and then its per-meeting statuses.
    #    Handle missing meeting statuses including at the end of the line.
    #      NOTE: With the current release of RubyXL (3.3.12), there's nothing we can do about the hyperlinks.
    #          They are properties of the sheet, not the cell.
    #          RubyXL::Reference.ref2ind(master.hyperlinks.first.ref.to_s)
    #          master.relationship_container.find_by_rid(master.hyperlinks.first.r_id)
    # 2. Write three rows on the Minutes sheet.
    rowno = 2
    Item.order(:number).each do |item|
      # Change_contents spoils the shared string thing, so don't write unless you have to.
      # Anyhow, when writing, rows and columns might not exist.
      master.add_or_chg(rowno, 0, item.number.to_s) # Use this method to ensure that the row exists
      master.add_or_chg(rowno, 1, item.date.strftime('%d-%b-%Y'))
      master.add_or_chg(rowno, 2, item.standard)
      master.add_or_chg(rowno, 3, item.clause)
      master.add_or_chg(rowno, 4, item.subject)
      master.add_or_chg(rowno, 5, item.draft)
      # There may not be a minutes entry corresponding to each meeting (=column), so keep a track of the item's current
      # status and use that where no minutes entry exists.
      current_sts = '-'
      colno = 6
      Meeting.order(:date).each do |mtg|
        min = item.minutes.where('minutes.meeting_id = ?', mtg.id).first
        current_sts = min.minst.code if min&.minst
        if master[rowno][colno].nil? || master[rowno][colno].blank?
          flash[:error] =
            "Missing prepared column in Master sheet, row #{rowno + 1}, column #{colno + 1}"
        end
        master.add_or_chg(rowno, colno, current_sts)
        colno += 1
      end
      # Write hash signs on the remaining cells in the row, adding new cells to the right if necessary.
      # Issue #29: master[rowno].cells.count comes out as a big number (16384) for unused rows.
      # Calculate the last column number instead.
      # Also, if there are more meetings than the input spreadsheet allowed for, there won't be cells for each meeting.
      lastcolno = Meeting.count + 6
      (colno..lastcolno).each do |colcolno|
        if master[rowno][colcolno].nil?
          master.add_cell(rowno, colcolno, '#')
        else
          master[rowno][colcolno].chg_cell('#')
        end
      end
      # Add a hash at the end of the row if there isn't one
      unless master[rowno][lastcolno + 1] && master[rowno][lastcolno + 1].value == '#'
        master.add_cell(rowno, lastcolno + 1, '#')
      end
      rowno += 1
    end
    # Fill the rest of the rows with hash signs.  Make sure there's at least one row of hashes.
    make_master_hash_row(master, rowno) unless master[rowno] && master[rowno][1] && master[rowno][1].value == '#'
    ((rowno + 1)..(master.count - 1)).each do |r|
      make_master_hash_row(master, r)
    end

    minutes = book['Minutes']
    rowno = 1
    Item.order(:number).each do |item|
      minutes.add_or_chg(rowno, 1, item.number.to_s)
      colno = 3
      Meeting.order(:date).each do |mtg|
        min = item.minutes.where('minutes.meeting_id = ?', mtg.id).first
        if min && !min.date.blank?
          datestr = min.date.strftime('%-d-%b-%Y')
          minutes.add_or_chg(rowno, colno, datestr)
        else
          minutes.delete_cell(rowno, colno)
        end
        if min && !min.text.blank?
          minutes.add_or_chg(rowno + 1, colno, min.text)
        else
          minutes.delete_cell(rowno + 1, colno)
        end
        if min && (!min.date.blank? || !min.text.blank?)
          minutes.add_or_chg(rowno + 2, colno, '#')
        else
          minutes.delete_cell(rowno + 2, colno)
        end
        colno += 1
      end
      rowno += 3
    end
    # Delete the rest of the rows, making sure the last row has a single '#' in the number column.
    # Note that delete_row pushes cells up, so we delete the same numbered row repeatedly.
    (rowno..(minutes.count - 1)).each { |_r| minutes.delete_row(rowno) }
    minutes.add_cell(rowno, 0, '')
    minutes.add_cell(rowno, 1, '#')

    book.write(outfname)

    respond_to do |format|
      format.html do
        response.headers['Content-Length'] = File.size(outfname).to_s
        send_file(outfname, type: @import.content_type, x_sendfile: true)
        return
      end
      format.json { render :show, status: :ok, location: @import }
    end
  end

  # DELETE /imports/1
  # DELETE /imports/1.json
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to imports_url, notice: 'Import was destroyed' }
      format.json { head :no_content }
    end
  end

  private

  def set_import
    @import = Import.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.require(:import).permit(:filename, :imported)
  end

  def make_master_hash_row(sheet, rowno)
    sheet.add_or_chg(rowno, 1, '#')
    sheet.delete_cell(rowno, 0)
    (2..5).each { |colno| sheet.delete_cell(rowno, colno) }
    (6..sheet[1].cells.count - 1).each { |colno| sheet.add_or_chg(rowno, colno, '#') }
  end
end
# rubocop:enable all
