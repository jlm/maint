class AddDraftUrlToProject < ActiveRecord::Migration
  def change
    add_column :projects, :draft_url, :string
  end
end
