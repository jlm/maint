class AddFieldsToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :date, :date
    add_column :requests, :name, :string
    add_column :requests, :company, :string
    add_column :requests, :email, :string
    add_column :requests, :standard, :string
    add_column :requests, :clauseno, :string
    add_column :requests, :clausetitle, :string
    add_column :requests, :rationale, :text
    add_column :requests, :proposal, :text
    add_column :requests, :impact, :text
  end
end
