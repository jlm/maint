require 'spreadsheet'

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
    puts "Uploaded file #{uploaded_io.original_filename}"
    filepath = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    @import.filename = filepath
    if uploaded_io.content_type == "application/vnd.ms-excel"
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      book = Spreadsheet.open filepath
      book.worksheets.each do |w|
        puts w.name
      end
      master = book.worksheet 'Master'
      minutes = book.worksheet 'Minutes'
      
      meetingnames = []
      meetnamerow = master.row(1)
      i = 6
      while meetnamerow[i].length > 1 do
        meetingnames << meetnamerow[i]
        meeting = Meeting.new
        titlewords = meetnamerow[i].split("\s")
        meeting.date = "1 " + titlewords[0] + " " + titlewords[1]
        meeting.meetingtype = titlewords[2]
        meeting.save!
        i += 1
      end
      i = 0
      puts "There are #{master.rows.count} rows altogether"
      master.each 2 do |itemrow|  # the 2 says skip the first two rows.
        i += 1
        next unless itemrow[0] =~ /\d\d\d\d/
        item = Item.new
        item.number = itemrow[0]
        day,month,year = itemrow[1].split('-')
        year = year.to_i
        year = year + 2000 if year < 100
        item.date = day.to_s + month.to_s + year.to_s
        item.standard = itemrow[2]
        item.clause = itemrow[3]
        item.subject = itemrow[4]
        item.draft = itemrow[5]
        item.save!
        # break if i > 5
      end

    else
      puts "#{filepath}: not an Excel spreadsheet"
    end


    respond_to do |format|
      if @import.save
        format.html { redirect_to @import, notice: 'Import was successfully created.' }
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
    respond_to do |format|
      if @import.update(import_params)
        format.html { redirect_to @import, notice: 'Import was successfully updated.' }
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
