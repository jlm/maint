require 'rails_helper'

RSpec.describe TaskGroupsController, type: :controller do
  let!(:chair) { FactoryBot.create(:chair) }

  before do
  end

  after do
    # Do nothing
  end

  describe "projects.create" do
    it "creates a new Project" do
      tg = TaskGroup.create!(chair: chair)
      newproj = tg.projects.create
      expect(newproj).to be_instance_of(Project)
    end
  end
end