class AddSpeedToRental < ActiveRecord::Migration
  def up
    add_column :rentals, :speed, :float
  end

  def down
    remove_column :rentals, :speed, :float
  end
end
