# frozen_string_literal: true

class TaskGroupsController < ApplicationController
  load_and_authorize_resource
  before_action :set_task_group, only: %i[show edit update destroy]
  respond_to :html, :json

  # GET /task_groups
  # GET /task_groups.json
  def index
    @task_groups = TaskGroup.all.paginate(page: params[:page], per_page: 10)
    # Search for items using OR: http://stackoverflow.com/questions/3639656/activerecord-or-query

    if params[:search].present?
      t = @task_groups.arel_table
      match_string = "%#{params[:search]}%"
      @task_groups = @task_groups.where(
        t[:name].matches(match_string)
      )
    end
  end

  # GET /task_groups/1
  # GET /task_groups/1.json
  def show
    @projects = @task_group.projects.order(:designation).paginate(page: params[:page], per_page: 10)
  end

  # GET /task_groups/new
  def new
    @task_group = TaskGroup.new
    respond_modal_with @task_group
  end

  # GET /task_groups/1/edit
  def edit
    respond_modal_with @task_group
  end

  # POST /task_groups
  # POST /task_groups.json
  def create
    @task_group = TaskGroup.new(task_group_params)
    flash[:notice] = "Task Group successfully created" if @task_group.save
    respond_modal_with @task_group
  end

  # PATCH/PUT /task_groups/1
  # PATCH/PUT /task_groups/1.json
  def update
    flash[:notice] = "Task Group successfully updated" if @task_group.update(task_group_params)
    respond_modal_with @task_group
  end

  # DELETE /task_groups/1
  # DELETE /task_groups/1.json
  def destroy
    @task_group.destroy
    respond_to do |format|
      format.html { redirect_to task_groups_url, notice: "Task group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_task_group
    @task_group = TaskGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_group_params
    params.require(:task_group).permit(:name, :abbrev, :vice_chair_id, :person_id, :chair_id, :page_url, :search)
  end
end
# rubocop:enable all
