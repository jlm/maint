class RequestsController < ApplicationController
  load_and_authorize_resource
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /items/1/requests
  def index
    @item = Item.find(params[:item_id])
    @request = @item.request
  end

  # GET /items/1/requests/20
  def show
    @item = Item.find(params[:item_id])
    #byebug
    @request = @item.request
    respond_modal_with [@item, @request]
  end

  # GET /items/1/requests/20/pre
  # This is an additional member route, which renders pre.html.erb, and just shows the same data differently formatted.
  def pre
    @item = Item.find(params[:item_id])
    #byebug
    @request = @item.request
    respond_modal_with [@item, @request]
  end

  # GET /items/1/requests/new
  def new
    @item = Item.find(params[:item_id])
    @item.request = Request.new
    respond_modal_with @item.request
  end

  # GET /items/1/requests/10/edit
  def edit
    @item = Item.find(params[:item_id])
    @request = @item.request
    respond_modal_with [@item, @request]
    #byebug
  end

  # POST /items/1requests
  # POST /items/1/requests.json
  def create
    @item = Item.find(params[:item_id])
    @request = Request.create(request_params)
    @item.request = @request
    @item.save
    respond_modal_with(@request, location: item_url(@item))
  end

  # PATCH/PUT /items/1/requests/1
  # PATCH/PUT /items/1/requests/1.json
  def update
    @item = Item.find(params[:item_id])
    flash[:notice] = "Request successfully updated" if @request.update(request_params)
    respond_modal_with(@request, location: item_url(@item))
  end

  # DELETE /items/1/requests/1
  # DELETE /items/1/requests/1.json
  def destroy
    @item = Item.find(params[:item_id])
    @request.destroy
    respond_to do |format|
      format.html { redirect_to item_url(@item), notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:standard, :clauseno, :clausetitle, :name, :email, :company, :rationale, :proposal,
                                      :impact, :date)
    end

end
