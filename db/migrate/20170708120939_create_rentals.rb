class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.string :name
      t.integer :number
      t.integer :mileage
      t.string :input_file

      t.timestamps
    end
  end
end
