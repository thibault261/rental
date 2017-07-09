require 'csv'
require 'net/http'
class Rental < ActiveRecord::Base
  mount_uploader :input_file, RentalUploader

  # VALIDATION -----------------------------------------------------------------
  validates :name, :input_file,  presence: true
  # /VALIDATION ----------------------------------------------------------------

  def mileage
    self[:mileage].to_f/1000.0
  end

  def calculate_mileage
    begin
      ################################
      ### Variables initialization ###
      ################################
      start_pos = {latitude: nil, longitude: nil}
      end_pos = {latitude: nil, longitude: nil}
      start_time = nil
      end_time = nil
      mileage = 0
      row_number = 1
      line_count = CSV.read(self.input_file.path, col_sep:";").count

      ####################################
      ## Browse CSV file line by line : ##
      ## calculate mileage and duration ##
      ####################################
      if line_count >= 2
        CSV.foreach(self.input_file.path, col_sep:";") do |timestamp, latitude, longitude|
          ## Set start_time (first timestamp) and end_time (last one) ##
          ## to calculate duration ##
          if row_number == 1
            start_time = Time.at(timestamp.to_i)
          elsif row_number == line_count
            end_time = Time.at(timestamp.to_i)
          end

          if row_number == 1
            ## First line : init start positions ('latitude' and 'longitude') ##
            start_pos[:latitude] = latitude.gsub(/\s+/, "").to_f
            start_pos[:longitude] = longitude.gsub(/\s+/, "").to_f

          elsif row_number <= line_count
            ## 2nd line & other : set end positions ('latitude' and 'longitude') ##
            end_pos[:latitude] = latitude.gsub(/\s+/, "").to_f
            end_pos[:longitude] = longitude.gsub(/\s+/, "").to_f

            ## Calculate distance in meters point by point (accuracy purpose) ##
            mileage += Rental.obtain_distance(start_pos, end_pos)

            ## End positions becomes start positions for next lines ##
            start_pos[:latitude] = end_pos[:latitude]
            start_pos[:longitude] = end_pos[:longitude]
            end_pos[:latitude] = nil
            end_pos[:longitude] = nil
          end
          row_number += 1
        end

        if !start_time.nil? and !end_time.nil? and end_time > start_time
          self.duration = TimeDifference.between(start_time, end_time).humanize
          hour = TimeDifference.between(start_time, end_time).in_hours
        end
        self.mileage = mileage
      end

      self.number = self.id
      self.save
    rescue => e
      raise StandardError.new("Problem while calculating mileage, duration and speed")
    end
  end

  def self.obtain_distance start_pos, end_pos
    ## Connect to API
    url = URI.parse("https://maps.googleapis.com/maps/api/distancematrix/json?mode=driving&units=metric&origins=#{start_pos[:latitude]},#{start_pos[:longitude]}&destinations=#{end_pos[:latitude]},#{end_pos[:longitude]}&key=AIzaSyD-fOHs4K0jYCyJS03uG1mEKl-pDox0Bv8")
    req = Net::HTTP::Get.new(url.request_uri)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == "https")
    response = JSON.parse(http.request(req).body)

    ## Extract the distance value in meter from the JSON structure ##
    distance = response["rows"].first["elements"].first["distance"]["value"].to_i

    return distance
  end

end
