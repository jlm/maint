class PeopleController < ApplicationController
  load_and_authorize_resource
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :set_role
  respond_to :html, :json

  # GET /people
  # GET /people.json
  def index
    @people = role_class.all.paginate(page: params[:page], per_page: 10)
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = role_class.new
    respond_modal_with @person
  end

  # GET /people/1/edit
  def edit
    respond_modal_with @person
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.create(person_params)
    respond_modal_with @person
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    flash[:notice] = "Person successfully updated" if @person.update(person_params)
    respond_modal_with @task_group
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html {redirect_to people_url, notice: 'Person was successfully destroyed.'}
      format.json {head :no_content}
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.

  def set_role
    @role = role
  end

  def role
    Person.roles.include?(params[:type]) ? params[:type] : "Person"
  end

  def role_class
    role.constantize
  end

  def set_person
    @person = role_class.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_params
    params.require(role.underscore.to_sym).permit(:first_name, :last_name, :email, :affiliation, :role)
  end
end
