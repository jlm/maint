class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /task_groups/1/projects
  # GET /task_groups/1/projects.json
  def index
    @task_group = TaskGroup.find(params[:task_group_id])
    @projects = @task_group.projects.order(:designation).paginate(page: params[:page], per_page: 10)
  end

  # GET /task_groups/1/projects/1
  # GET /task_groups/1/projects/1.json
  def show
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:id])
  end

  # GET /task_groups/1/projects/new
  def new
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.build
    respond_modal_with @project
  end

  # GET /task_groups/1/projects/1/edit
  def edit
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:id])
    respond_modal_with(@project, location: task_group_url(@task_group))
  end

  # POST /task_groups/1/projects
  # POST /task_groups/1/projects.json
  def create
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.create(project_params)
    @task_group.save
    respond_modal_with(@project, location: task_group_url(@task_group))
  end

  # PATCH/PUT /task_groups/1/projects/1
  # PATCH/PUT /task_groups/1/projects/1.json
  def update
    @task_group = TaskGroup.find(params[:task_group_id])
    flash[:notice] = "Project successfully updated" if @project.update(project_params) && @task_group.save
    respond_modal_with(@project, location: task_group_url(@task_group))
  end

  # DELETE /task_groups/1/projects/1
  # DELETE /task_groups/1/projects/1.json
  def destroy
    @task_group = TaskGroup.find(params[:task_group_id])
    @project.destroy
    respond_to do |format|
      format.html { redirect_to task_group_url(@task_group), notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:task_group_id, :designation, :title, :short_title, :project_type, :status, :last_motion, :draft_no, :next_action, :pool_formed, :mec, :par_url, :csd_url, :par_approval, :par_expiry, :standard_approval, :published)
    end
end
