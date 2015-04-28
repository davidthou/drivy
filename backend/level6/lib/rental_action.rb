class RentalAction
  attr_reader :who, :type, :amount

  def initialize(args)
    @who = args[:who]
    @type = args[:type]
    @amount = args[:amount]
  end

  def to_hash
    {
      who: who,
      type: type,
      amount: amount
    }
  end
end
