class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  respond_to :html, :json

  # GET /task_group/1/project/1/events
  # GET /task_group/1/project/1/events.json
  def index
    @project = Project.find(params[:project_id])
    @task_group = @project.task_group
    @events = @project.events.order(:date)
    @events = @events.paginate(page: params[:page], per_page: 10) unless request.format == :json
    # Search for events using OR: http://stackoverflow.com/questions/3639656/activerecord-or-query
    if params[:search].present?
      t = @events.arel_table
      match_string = '%' + params[:search] + '%'
      @events = @events.where(
          t[:name].matches(match_string) # Note this is not an exact string match.  Caller beware!
      )
    end
  end

  # GET /task_group/1/project/1/events/1
  # GET /task_group/1/project/1/events/1.json
  def show
    @project = Project.find(params[:project_id])
    @task_group = @project.task_group
    @event = @project.events.find(params[:id])
  end

  # GET /task_group/1/project/1/events/new
  def new
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:project_id])
    @event = @project.events.build
    respond_modal_with @event
  end

  # GET /task_group/1/project/1/events/1/edit
  def edit
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:project_id])
    @event = @project.events.find(params[:id])
    respond_modal_with(@event, location: task_group_project_url(@task_group, @project))
  end

  # POST /task_group/1/project/1/events
  # POST /task_group/1/project/1/events.json
  def create
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:project_id])
    @event = @project.events.create(event_params)
    @project.save
    respond_modal_with(@event, location: task_group_project_url(@task_group, @project))
  end

  # PATCH/PUT /task_group/1/project/1/events/1
  # PATCH/PUT /task_group/1/project/1/events/1.json
  def update
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:project_id])
    flash[:notice] = "Event successfully updated" if @event.update(event_params) && @project.save
    respond_modal_with(@event, location: task_group_project_url(@task_group, @project))
  end

  # DELETE /task_group/1/project/1/events/1
  # DELETE /task_group/1/project/1/events/1.json
  def destroy
    @task_group = TaskGroup.find(params[:task_group_id])
    @project = @task_group.projects.find(params[:project_id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to task_group_project_url(@task_group, @project), notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:task_group_id, :project_id, :name, :date, :end_date, :url, :description, :project)
    end
end
