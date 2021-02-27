class Action
  attr_reader :who, :type, :amount

  def initialize(who:, type:, amount:)
    @who = who
    @type = type
    @amount = amount
  end

  def serialize
    {
      who: who,
      type: type,
      amount: amount
    }
  end
end
