class AddDurationToRental < ActiveRecord::Migration
  def up
    add_column :rentals, :duration, :integer
  end

  def down
    remove_column :rentals, :duration, :integer
  end
end
