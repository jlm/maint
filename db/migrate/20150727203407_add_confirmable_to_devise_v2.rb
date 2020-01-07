class AddConfirmableToDeviseV2 < ActiveRecord::Migration[4.2]
  def change
  	change_table(:users) do |t|
  		t.string	:unconfirmed_email
  	end
  end
end
