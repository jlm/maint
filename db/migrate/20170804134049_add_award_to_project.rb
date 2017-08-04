class AddAwardToProject < ActiveRecord::Migration
  def change
    add_column :projects, :award, :string
  end
end
