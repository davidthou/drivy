require 'json'
require_relative 'lib/car'
require_relative 'lib/rental'
require_relative 'lib/rental_options'
require_relative 'lib/rental_modification'

class Drivy
  INPUT_FILENAME = 'data.json'
  OUTPUT_FILENAME = 'output.json'

  def self.create_output!
    data = parsed_input
    cars = load_cars(data['cars'])
    rentals = load_rentals(data['rentals'], cars)
    rental_modifications = load_rental_modifications(
      data['rental_modifications'],
      rentals
    )

    output_file = File.open(OUTPUT_FILENAME, 'w')
    output_file.write(rental_modifications_json(
      rental_modifications.map do |rental_modification|
        rental_modification.to_hash
      end
      )
    )
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
        rentals[rental['id']] = Rental.new(
          id: rental['id'], car: cars[rental['car_id']],
          start_date: rental['start_date'],
          end_date: rental['end_date'], distance: rental['distance'],
          options: RentalOptions.new(
            deductible_reduction: rental['deductible_reduction']
          )
        )
      end
    end
    rentals
  end

  def self.load_rental_modifications(rental_modification_data, rentals)
    rental_modifications = []
    rental_modification_data.each do |rental_modification|
      unless rentals[rental_modification['rental_id']].nil?
        rental_modifications << RentalModification.new(
          id: rental_modification['id'],
          rental: rentals[rental_modification['rental_id']],
          start_date: rental_modification['start_date'],
          end_date: rental_modification['end_date'],
          distance: rental_modification['distance']
        )
      end
    end
    rental_modifications
  end

  def self.rental_modifications_json(rental_modifications)
    JSON.pretty_generate(rental_modifications: rental_modifications)
  end
end

Drivy.create_output!
