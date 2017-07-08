class AddSpeedToRental < ActiveRecord::Migration
  def up
    add_column :rentals, :speed, :integer
  end

  def down
    remove_column :rentals, :speed, :integer
  end
end
