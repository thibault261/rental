require 'csv'
require 'net/http'
class Rental < ActiveRecord::Base
  mount_uploader :input_file, RentalUploader

  ## [{start: [lat, long], end: [lat, long]}, {start: [lat, long], ...}, ... ] ##
  serialize :positions, Array

  validates :name, :input_file,  presence: true

  # Redefine speed getter to round values
  def speed
    self[:speed].round(2) if !self[:speed].nil?
  end

  # Redefine mileage getter to round values
  def mileage
    self[:mileage].round(3) if !self[:mileage].nil?
  end

  def calculate_mileage
    begin
      ## Variables initialization ##
      start_pos = [nil, nil] ## [latitude, longitude]
      end_pos = [nil, nil]   ## [latitude, longitude]
      start_time = nil
      end_time = nil
      distance_in_meters = 0
      row_number = 1
      line_count = CSV.read(self.input_file.path, col_sep:";").count

      ## Browse CSV file line by line : ##
      ## calculate mileage and duration ##
      if line_count >= 2
        CSV.foreach(self.input_file.path, col_sep:";") do |timestamp, latitude, longitude|

          ## Set start_time (first timestamp) and end_time (last one) ##
          ## to calculate duration ##
          if row_number == 1
            start_time = Time.at(timestamp.to_i)
          elsif row_number == line_count
            end_time = Time.at(timestamp.to_i)
          end

          ## Calculate mileage
          if row_number == 1
            ## First line : init start positions ('latitude' and 'longitude') ##
            start_pos = [latitude.gsub(/\s+/, "").to_f, longitude.gsub(/\s+/, "").to_f]

          elsif row_number <= line_count
            ## 2nd line & other : set end positions ('latitude' and 'longitude') ##
            end_pos = [latitude.gsub(/\s+/, "").to_f, longitude.gsub(/\s+/, "").to_f]

            ## Save positions avoiding duplicates (When the vehicle has not moved) ##
            if start_pos != end_pos
              self.positions.push({start: start_pos, end: end_pos})
            end

            ## End positions becomes start positions for next line ##
            start_pos = end_pos.dup
            end_pos = nil

          end
          row_number += 1
        end

        if !start_time.nil? and !end_time.nil? and end_time > start_time
          self.duration = TimeDifference.between(start_time, end_time).humanize
        end

        ## Calculate total distance in meters point by point (accuracy purpose) ##
        distance_in_meters = self.calculate_total_distance

        ## Set mileage (in kilometers) ##
        self.mileage = distance_in_meters.to_f/1000.0
        ## Set average speed (kilometers by hour) ##
        self.speed = self.mileage.to_f/TimeDifference.between(start_time, end_time).in_hours.to_f
      end

      self.number = self.id
      self.save
    rescue => e
      raise StandardError.new("Problem during proces, possible reason : #{e}")
    end
  end

  ## Retrieve the total distance in meter from rental positions,             ## 
  ## segment by segment (accuracy purpose) with Goole Distance Matrix API    ##
  def calculate_total_distance
    ## Variables initialization ##
    query = ""
    threads = []
    urls = []
    queries = []
    total_distance_in_meters = 0
    corrected_points = []
    start_pos = []
    end_pos = []
    points_number_in_query = 0

    ###############################
    ####### 'Roads API' part ######
    ###############################

    ## Construct query for 'Roads API' requests ##
    self.positions.each_with_index do |segment, i|
      query += "#{segment[:start][0]},#{segment[:start][1]}|#{segment[:end][0]},#{segment[:end][1]}|"
      points_number_in_query += 2 ## Two points : start and end ##

      ## 'Roads API' constraint : no more thant 100 points by request ##
      if points_number_in_query == 100 or i == ((self.positions.length) -1)
        queries.push(query)
        query = ""
        points_number_in_query = 0
      end
    end
    
    ## Call 'Roads API' to refine the path by correcting the points coordinates ##
    queries.each do |query|
      encoded_url = URI.encode("https://roads.googleapis.com/v1/snapToRoads?path="+query[0..-2]+"&key=AIzaSyD-fOHs4K0jYCyJS03uG1mEKl-pDox0Bv8")
      uri = URI.parse(encoded_url)
      req = Net::HTTP::Get.new(uri.request_uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      response = JSON.parse(http.request(req).body)

      ## Retrieve corrected coordinates from the JSON response ##
      response["snappedPoints"].each_with_index do |snapped_point, i|
        corrected_point_lat = snapped_point["location"]["latitude"]
        corrected_point_long = snapped_point["location"]["longitude"]

        if i == 0
          start_pos = [corrected_point_lat, corrected_point_long]
        else
          end_pos = [corrected_point_lat, corrected_point_long]
          if start_pos != end_pos
            ## Save them in
            corrected_points.push({start: start_pos, end: end_pos})
          end
          start_pos = end_pos.dup
          end_pos = nil
        end
      end
    end

    ################################
    ## 'Matrix Distance API' part ##
    ################################

    ## Compute URL list from positions data ##
    corrected_points.each do |segment|
      origin = segment[:start]
      destination = segment[:end]

      urls.push "https://maps.googleapis.com/maps/api/distancematrix/json?mode=driving&units=metric&origins=#{origin[0]},#{origin[1]}&destinations=#{destination[0]},#{destination[1]}&key=AIzaSyD-fOHs4K0jYCyJS03uG1mEKl-pDox0Bv8"
    end

    ## Call google api "Matrix Distance" for each segment ##
    urls.each do |url|
      ## Use Thread to "imitate" asynchronous request ##
      threads << Thread.new do
        uri = URI.parse(url)
        req = Net::HTTP::Get.new(uri.request_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        response = JSON.parse(http.request(req).body)

        ## Extract the distance value in meter from the JSON structure ##
        segment_distance = response["rows"].first["elements"].first["distance"]["value"].to_i
        total_distance_in_meters += segment_distance.to_f
      end

      ## Wait for threads to finish before ending program ##
      threads.each { |t| t.join }
    end

    ##  Return the distance ##
    return total_distance_in_meters
  end

end
