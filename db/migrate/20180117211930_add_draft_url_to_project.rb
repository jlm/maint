class AddDraftUrlToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :draft_url, :string
  end
end
