class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.string :type
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :affiliation

      t.timestamps null: false
    end
  end
end
