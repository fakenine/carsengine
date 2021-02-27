# frozen_string_literal: true

# Class to represent an action/transfer of funds
class Action
  attr_reader :who, :type
  attr_accessor :amount

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
