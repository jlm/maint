class MinutesController < ApplicationController
  load_and_authorize_resource
  before_action :set_minute, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

# GET /minutes
  # GET /minutes.json
  def index
    @item = Item.find(params[:item_id])
    @minutes = @item.minutes.order(:date).paginate(page: params[:page], per_page: 10)
  end

  # GET /minutes/1
  # GET /minutes/1.json
  def show
    @item = Item.find(params[:item_id])
    #byebug
    @minute = @item.minutes.find(params[:id])
  end

  # GET /minutes/new
  def new
    @item = Item.find(params[:item_id])
    @minute = @item.minutes.build
    @meetings = Meeting.all
    respond_modal_with @minute
  end

  # GET /items/:item_id/minutes/1/edit
  def edit
    @item = Item.find(params[:item_id])
    @minute = @item.minutes.find(params[:id])
    respond_modal_with(@minute, location: item_url(@item))
  end

  # POST /minutes
  # POST /minutes.json
  def create
    @item = Item.find(params[:item_id])
    @minute = @item.minutes.create(minute_params)
    respond_modal_with(@minute, location: item_url(@item))
  end

  # PATCH/PUT /minutes/1
  # PATCH/PUT /minutes/1.json
  def update
    @item = Item.find(params[:item_id])
    flash[:notice] = "Minute successfully updated" if @minute.update(minute_params) && @item.save
    respond_modal_with(@minute, location: item_url(@item))
=begin
    respond_to do |format|
      if @minute.update(minute_params) && @item.save
        format.html { redirect_to item_url(@item), notice: 'Minute was successfully updated.' }
        format.json { render :show, status: :ok, location: @minute }
      else
        format.html { render :edit }
        format.json { render json: @minute.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /minutes/1
  # DELETE /minutes/1.json
  def destroy
    @item = Item.find(params[:item_id])
    @minute.destroy
    respond_to do |format|
      format.html { redirect_to item_url(@item), notice: 'Minute was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_minute
      @minute = Minute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def minute_params
      params.require(:minute).permit(:date, :text, :minst_id, :minute_id, :item_id, :meeting_id)
    end
end
