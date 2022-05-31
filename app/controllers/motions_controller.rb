# frozen_string_literal: true

class MotionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_motion, only: %i[show edit update destroy]
  respond_to :html, :json

  # GET /meetings/:meeting_id/motions
  # GET /meetings/:meeting_id/motions.json
  def index
    @meeting = Meeting.find(params[:meeting_id])
    @motions = @meeting.motions.order(:number).paginate(page: params[:page], per_page: 10)
  end

  # GET /meetings/:meeting_id/motions/1
  # GET /meetings/:meeting_id/motions/1.json
  def show
    @meeting = Meeting.find(params[:meeting_id])
    @motion = @meeting.motions.find(params[:id])
  end

  # GET /meetings/:meeting_id/motions/new
  def new
    @meeting = Meeting.find(params[:meeting_id])
    @motion = @meeting.motions.build
    respond_modal_with @motion
  end

  # GET /meetings/:meeting_id/motions/1/edit
  def edit
    @meeting = Meeting.find(params[:meeting_id])
    @motion = @meeting.motions.find(params[:id])
    respond_modal_with(@motion, location: meeting_url(@meeting))
  end

  # POST /meetings/:meeting_id/motions
  # POST /meetings/:meeting_id/motions.json
  def create
    @meeting = Meeting.find(params[:meeting_id])
    @motion = @meeting.motions.create(motion_params)
    @meeting.save
    respond_modal_with(@motion, location: meeting_url(@meeting))
  end

  # PATCH/PUT /meetings/:meeting_id/motions/1
  # PATCH/PUT /meetings/:meeting_id/motions/1.json
  def update
    @meeting = Meeting.find(params[:meeting_id])
    flash[:notice] = "Motion successfully updated" if @motion.update(motion_params) && @meeting.save
    respond_modal_with(@motion, location: meeting_url(@meeting))
  end

  # DELETE /meetings/:meeting_id/motions/1
  # DELETE /meetings/:meeting_id/motions/1.json
  def destroy
    @meeting = Meeting.find(params[:meeting_id])
    @motion.destroy
    respond_to do |format|
      format.html { redirect_to meeting_url(@meeting), notice: "Motion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_motion
    @motion = Motion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def motion_params
    params.require(:motion).permit(:meeting_id, :project_id, :motion_text, :number)
  end
end
# rubocop:enable all
