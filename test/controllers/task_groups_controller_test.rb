require 'test_helper'

class TaskGroupsControllerTest < ActionController::TestCase
  setup do
    @task_group = task_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:task_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task_group" do
    assert_difference('TaskGroup.count') do
      post :create, task_group: { chair_id: @task_group.chair_id, name: @task_group.name, vice_chair_id: @task_group.vice_chair_id }
    end

    assert_redirected_to task_group_path(assigns(:task_group))
  end

  test "should show task_group" do
    get :show, id: @task_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task_group
    assert_response :success
  end

  test "should update task_group" do
    patch :update, id: @task_group, task_group: { chair_id: @task_group.chair_id, name: @task_group.name, vice_chair_id: @task_group.vice_chair_id }
    assert_redirected_to task_group_path(assigns(:task_group))
  end

  test "should destroy task_group" do
    assert_difference('TaskGroup.count', -1) do
      delete :destroy, id: @task_group
    end

    assert_redirected_to task_groups_path
  end
end
