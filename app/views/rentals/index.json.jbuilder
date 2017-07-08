json.array!(@rentals) do |rental|
  json.extract! rental, :id, :name, :number, :mileage, :input_file
  json.url rental_url(rental, format: :json)
end
