class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /task_groups/1/projects
  # GET /task_groups/1/projects.json
  def index
    if params[:task_group_id].present?
      @task_group = TaskGroup.find(params[:task_group_id])
      @projects = @task_group.projects.order(:designation)
    else
      @projects = Project.all.order(:designation)
    end
    # A dirty hack to avoid having to deal with pagination in API clients.  This does not scale.
    @projects = @projects.paginate(page: params[:page], per_page: 10) unless request.format == :json
    # Search for projects using OR: http://stackoverflow.com/questions/3639656/activerecord-or-query
    if params[:search].present?
      t = @projects.arel_table
      match_string = '%' + params[:search] + '%'
      @projects = @projects.where(
          t[:designation].matches(match_string)
      )
    end
  end

  # GET /task_groups/1/projects/1
  # GET /task_groups/1/projects/1.json
  def show
    if params[:task_group_id].present?
      @task_group = TaskGroup.find(params[:task_group_id])
      @project = @task_group.projects.find(params[:id])
    else
      @project = Project.find(params[:id])
      @task_group = @project.task_group
    end
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
    @project.events.each do |e|
      e.destroy
    end
    @project.destroy
    respond_to do |format|
      format.html { redirect_to task_group_url(@task_group), notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /task_groups/1/projects/1/timeline
  # GET /task_groups/1/projects/1/timeline.json
  def show_timeline
    if params[:task_group_id].present?
      @task_group = TaskGroup.find(params[:task_group_id])
      @project = @task_group.projects.find(params[:project_id])
    else
      @project = Project.find(params[:project_id])
      @task_group = @project.task_group
    end
  end

  # GET /timeline/[:designation]
  # GET /timeline/[:designation].json
  def show_timeline_by_desig
    desig = params[:designation].sub('-', '.')
    @project = Project.where(designation: desig).first!
    render 'show_timeline'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:task_group_id, :designation, :title, :short_title, :project_type, :status,
                                      :last_motion, :draft_no, :next_action, :award, :pool_formed, :mec, :par_url,
                                      :csd_url, :files_url, :draft_url, :par_approval, :par_expiry, :standard_approval,
                                      :published)
    end
end
