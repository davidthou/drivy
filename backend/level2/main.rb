require 'json'
require_relative 'lib/car.rb'
require_relative 'lib/rental.rb'

class Drivy
  INPUT_FILENAME = 'data.json'
  OUTPUT_FILENAME = 'output.json'

  def self.create_output!
    data = parsed_input
    cars = load_cars(data['cars'])
    rentals = load_rentals(data['rentals'], cars)

    output_file = File.open(OUTPUT_FILENAME, 'w')
    output_file.write(output_rentals_json(rentals))
  end

  private

  def self.raw_input
    File.read(INPUT_FILENAME)
  end

  def self.parsed_input
    JSON.parse(raw_input)
  end

  def self.load_cars(cars_data)
    cars = []
    cars_data.each do |car|
      cars[car['id']] = Car.new(car['id'], car['price_per_day'], car['price_per_km'])
    end
    cars
  end

  def self.load_rentals(rentals_data, cars)
    rentals = []
    rentals_data.each do |rental|
      unless cars[rental['car_id']].nil?
        rentals << Rental.new(rental['id'], cars[rental['car_id']], rental['start_date'],
                              rental['end_date'], rental['distance'])
      end
    end
    rentals
  end

  def self.output_rentals_json(rentals)
    rentals_hash = rentals.map do |rental|
      { id: rental.id, price: rental.cost }
    end

    JSON.pretty_generate(rentals: rentals_hash)
  end
end

Drivy.create_output!
