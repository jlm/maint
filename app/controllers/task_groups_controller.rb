class TaskGroupsController < ApplicationController
  before_action :set_task_group, only: [:show, :edit, :update, :destroy]

  # GET /task_groups
  # GET /task_groups.json
  def index
    @task_groups = TaskGroup.all
  end

  # GET /task_groups/1
  # GET /task_groups/1.json
  def show
  end

  # GET /task_groups/new
  def new
    @task_group = TaskGroup.new
    #@chair_id = nil
    #binding.pry
  end

  # GET /task_groups/1/edit
  def edit
  end

  # POST /task_groups
  # POST /task_groups.json
  def create
    @task_group = TaskGroup.new(task_group_params)
    @task_group.chair = @task_group.person

    respond_to do |format|
      if @task_group.save
        format.html { redirect_to @task_group, notice: 'Task group was successfully created.' }
        format.json { render :show, status: :created, location: @task_group }
      else
        format.html { render :new }
        format.json { render json: @task_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_groups/1
  # PATCH/PUT /task_groups/1.json
  def update
    respond_to do |format|
      if @task_group.update(task_group_params)
        format.html { redirect_to @task_group, notice: 'Task group was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_group }
      else
        format.html { render :edit }
        format.json { render json: @task_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_groups/1
  # DELETE /task_groups/1.json
  def destroy
    @task_group.destroy
    respond_to do |format|
      format.html { redirect_to task_groups_url, notice: 'Task group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_group
      @task_group = TaskGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_group_params
      params.require(:task_group).permit(:name, :vice_chair_id, :person_id)
    end
end
