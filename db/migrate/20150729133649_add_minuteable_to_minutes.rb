class AddMinuteableToMinutes < ActiveRecord::Migration
  def change
    add_reference :minutes, :minuteable, polymorphic: true, index: true
  end
end
