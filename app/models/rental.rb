require 'csv'
class Rental < ActiveRecord::Base
  mount_uploader :input_file, RentalUploader

  # VALIDATION -----------------------------------------------------------------
  validates :name, :input_file,  presence: true
  # /VALIDATION ----------------------------------------------------------------

  def calculate_mileage
    CSV.foreach(self.input_file.path, headers: false, col_sep: ";", encoding: "UTF-8") do |row|
    end
  end
end
