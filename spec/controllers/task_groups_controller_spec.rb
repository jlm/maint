require 'rails_helper'

RSpec.describe TaskGroupsController, type: :controller do
  before do
  end

  after do
    # Do nothing
  end

  describe "GET index" do
    context "with an empty TaskGroup list" do
      it "assigns @task_groups" do
        tg = TaskGroup.create
        get :index
        expect(assigns(:task_groups)).to eq([tg])
      end
    end
  end

  describe "projects.create" do
    it "creates a new Project" do
      tg = TaskGroup.create
      newproj = tg.projects.create
      expect(newproj).to be_instance_of(Project)
    end
  end
end