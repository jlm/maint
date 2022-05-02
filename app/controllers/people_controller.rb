# frozen_string_literal: true

# rubocop:disable Style/Documentation

class PeopleController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :set_person, only: %i[show edit update destroy]
  before_action :set_role
  respond_to :html, :json, :csv

  # GET /people
  # GET /people.json
  # rubocop:disable Metrics/AbcSize

  def index
    @people = role_class.all
    @people = @people.paginate(page: params[:page], per_page: 10) unless request.format == :json
    # Search for people using OR: http://stackoverflow.com/questions/3639656/activerecord-or-query
    # rubocop:disable Style/GuardClause

    if params[:search].present?
      t = @people.arel_table
      match_string = "%#{params[:search]}%"
      @people = @people.where(t[:last_name].matches(match_string))
    end
    # rubocop:enable Style/GuardClause
  end

  # GET /people/1
  # GET /people/1.json
  def show; end

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
  # rubocop:disable Metrics/MethodLength

  def create
    @person = role_class.new(person_params)
    respond_with do |format|
      if @person.save
        format.html { redirect_to people_path, notice: 'Person was successfully created' }
        format.json { render json: @person, status: :created, location: @person }
      else
        format.html do
          puts @person.errors.full_messages.to_sentence
          render :new, notice: @person.errors.full_messages.to_sentence
        end
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    flash[:notice] = 'Person successfully updated' if @person.update(person_params)
    respond_modal_with @person
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_role
    @role = role
  end

  def role
    Person.roles.include?(params[:type]) ? params[:type] : 'Person'
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
          .delete_if { |param, val| param == 'role' && !(Person.roles.include? val) }
  end
end

# rubocop:enable all
