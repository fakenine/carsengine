# frozen_string_literal: true

require './action'

# Service used to calculate the actions on a rental
class ActionsCalculator
  attr_reader :price, :commission
  attr_accessor :actions

  def initialize(price, commission)
    @price = price
    @commission = commission
    @actions = []

    compute
  end

  private

  def compute
    @actions = [
      Action.new(who: 'driver', type: 'debit', amount: @price),
      Action.new(who: 'owner', type: 'credit', amount: @price - @commission.total_fees),
      Action.new(who: 'insurance', type: 'credit', amount: @commission.insurance_fee),
      Action.new(who: 'assistance', type: 'credit', amount: @commission.assistance_fee),
      Action.new(who: 'drivy', type: 'credit', amount: @commission.drivy_fee)
    ]
  end
end
