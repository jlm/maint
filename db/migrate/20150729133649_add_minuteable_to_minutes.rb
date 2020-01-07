class AddMinuteableToMinutes < ActiveRecord::Migration[4.2]
  def change
    add_reference :minutes, :minuteable, polymorphic: true, index: true
  end
end
