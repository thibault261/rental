class AddSerializedPositionsToRental < ActiveRecord::Migration
  def up
    add_column :rentals, :positions, :text
  end

  def down
    remove_column :rentals, :positions, :text
  end
end
