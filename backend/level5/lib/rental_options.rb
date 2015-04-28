class RentalOptions
  attr_reader :deductible_reduction

  def initialize(args)
    @deductible_reduction = args[:deductible_reduction]
  end
end
