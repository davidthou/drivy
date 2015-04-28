require_relative 'rental'
require_relative 'rental_action'

class RentalModification
  attr_reader :id, :rental, :start_date, :end_date, :distance

  def initialize(args)
    @id = args[:id]
    @rental = args[:rental]
    @start_date = args[:start_date]
    @end_date = args[:end_date]
    @distance = args[:distance]
  end

  def modified_rental
    Rental.new(
      id: rental.id,
      car: rental.car,
      start_date: start_date || rental.start_date,
      end_date: end_date || rental.end_date,
      distance: distance || rental.distance,
      options: rental.options
    )
  end

  def actions
    rental.actions.map.with_index do |rental_action, index|
      delta = modified_rental.actions[index].amount - rental_action.amount
      RentalAction.new(
        who: rental_action.who,
        type: action_type(rental_action.type, delta),
        amount: delta.abs
      )
    end
  end

  def to_hash
    {
      id: id,
      rental_id: rental.id,
      actions: actions.map { |action| action.to_hash  }
    }
  end

  private

  def action_type(original_type, delta)
    if delta < 0
      return 'debit' if original_type == 'credit'
      return 'credit' if original_type == 'debit'
    else
      return original_type
    end
  end
end
