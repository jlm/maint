class ItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /items
  # GET /items.json
  def index
    #byebug
    @items = Item.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    @items = @items.open if params[:open].present?
    @items = @items.closed if params[:closed].present?
    @items = @items.where(latest_status: params[:cat]) if params[:cat].present?

    # Search for items using OR: http://stackoverflow.com/questions/3639656/activerecord-or-query
    if params[:search].present?
      t = @items.arel_table
      match_string = '%' + params[:search] + '%'
      @items = @items.where(
        t[:number].eq(params[:search]).or(t[:standard].matches(match_string)).or(t[:draft].matches(match_string))
        )
    end

    if params[:open].present?
      @qualifier = "Open"
    elsif params[:closed].present?
      @qualifier = "Closed"
    elsif params[:search].present?
      @qualifier = ""
    else
      @qualifier = "All"
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    #@minutes = @item.minutes.where("minutes.DATE is not null").joins(:meetings).order("meetings.DATE").paginate(page: params[:page], per_page: 10)
    @minutes = @item.minutes.where("minutes.DATE is not null").joins(:meeting).order("meetings.date").paginate(page: params[:page], per_page: 10)
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
      #byebug
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:number, :date, :standard, :clause, :subject, :draft, :open, :closed, :search, :cat)
    end

    # From http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sort_column
      Item.column_names.include?(params[:sort]) ? params[:sort] : "number"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
