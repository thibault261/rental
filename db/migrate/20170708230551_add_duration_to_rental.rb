class AddDurationToRental < ActiveRecord::Migration
  def up
    add_column :rentals, :duration, :string
  end

  def down
    remove_column :rentals, :duration, :string
  end
end
