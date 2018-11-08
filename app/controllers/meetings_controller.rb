class MeetingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  respond_to :html, :json

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
    @items = @meeting.items.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
    respond_modal_with @meeting
  end

  # GET /meetings/1/edit
  def edit
    respond_modal_with @meeting
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.create(meeting_params)
    respond_modal_with @meeting
  end

  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    flash[:notice] = "Meeting successfully updated" if @meeting.update(meeting_params)
    respond_modal_with @meeting, location: meetings_url
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to meetings_url, notice: 'Meeting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:date, :meetingtype, :location, :minutes_url)
    end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Item.column_names.include?(params[:sort]) ? params[:sort] : "date"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
