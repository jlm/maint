class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.references :task_group, index: true, foreign_key: true
      t.references :base, index: true
      t.string :designation
      t.string :title
      t.string :short_title
      t.string :project_type
      t.string :status
      t.string :last_motion
      t.string :draft_no
      t.string :next_action
      t.date :pool_formed
      t.date :mec
      t.string :par_url
      t.string :csd_url
      t.date :par_approval
      t.date :par_expiry
      t.date :standard_approval
      t.date :published

      t.timestamps null: false
    end
  end
end
