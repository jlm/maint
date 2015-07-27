class AddConfirmableToDeviseV2 < ActiveRecord::Migration
  def change
  	change_table(:users) do |t|
  		t.string	:unconfirmed_email
  	end
  end
end
