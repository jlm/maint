require "test_helper"

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post :create, project: {csd_url: @project.CsdUrl, designation: @project.Designation, draft_no: @project.DraftNo, last_motion: @project.LastMotion, mec: @project.Mec, next_action: @project.NextAction, par_approval: @project.ParApproval, par_expiry: @project.ParExpiry, par_url: @project.ParUrl, pool_formed: @project.PoolFormed, project_type: @project.ProjectType, published: @project.Published, short_title: @project.ShortTitle, standard_approval: @project.StandardApproval, status: @project.Status, task_group_id: @project.TaskGroup_id, title: @project.Title}
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: {csd_url: @project.CsdUrl, designation: @project.Designation, draft_no: @project.DraftNo, last_motion: @project.LastMotion, mec: @project.Mec, next_action: @project.NextAction, par_approval: @project.ParApproval, par_expiry: @project.ParExpiry, par_url: @project.ParUrl, pool_formed: @project.PoolFormed, project_type: @project.ProjectType, published: @project.Published, short_title: @project.ShortTitle, standard_approval: @project.StandardApproval, status: @project.Status, task_group_id: @project.TaskGroup_id, title: @project.Title}
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end
end
