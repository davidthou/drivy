require 'date'
require_relative 'rental_commission'

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

  def commission
    @commission ||= RentalCommission.new(insurance_fee, assistance_fee, drivy_fee)
  end

  private

  def total_commission
    @total_commission ||= (cost * 0.3).to_i
  end

  def insurance_fee
    @insurance_fee ||= total_commission / 2
  end

  def assistance_fee
    @assistance_fee ||= 100 * rental_days
  end

  def drivy_fee
    total_commission - insurance_fee - assistance_fee
  end

  def rental_days
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def price_per_day
    car.price_per_day
  end

  def time_cost
    cost = 0

    1.upto(rental_days) do |index|
      if index > 10
        cost += price_per_day * 0.5
      elsif index > 4
        cost += price_per_day * 0.7
      elsif index > 1
        cost += price_per_day * 0.9
      else
        cost += price_per_day
      end
    end

    cost.to_i
  end

  def distance_cost
    distance * car.price_per_km
  end
end
