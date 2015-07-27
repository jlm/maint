class AddConfirmableToDeviseV1 < ActiveRecord::Migration
  def change
  	change_table(:users) do |t|
  		t.string	:confirmation_token
  		t.datetime	:confirmed_at
  		t.datetime	:confirmation_sent_at

  		t.integer	:failed_attempts, :default => 0
  		t.string	:unlock_token
  		t.datetime	:locked_at
  	end
  	add_index :users, :confirmation_token, :unique => true
  end
end
