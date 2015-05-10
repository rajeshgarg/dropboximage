json.array!(@image) do |playground|
  json.extract! playground, :name, :sport, :latitude, :longitude, :street_number, :route, :city, :country, :postal_code
  json.url playground_url(image, format: :json)
end
