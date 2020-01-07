class AddAwardToProject < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :award, :string
  end
end
