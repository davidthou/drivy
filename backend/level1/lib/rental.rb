require 'date'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def cost
    time_cost + distance_cost
  end

  private

  def rental_days
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def time_cost
    rental_days * car.price_per_day
  end

  def distance_cost
    distance * car.price_per_km
  end
end
