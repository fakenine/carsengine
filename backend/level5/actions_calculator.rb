require './action'

class ActionsCalculator
  attr_reader :price, :commission, :duration, :rental_options
  attr_accessor :actions

  def initialize(price, commission, duration, options)
    @price = price
    @commission = commission
    @duration = duration
    @actions = init_actions
    @options = options

    compute_options if @options.any?
  end

  def serialize
    @actions.values.map(&:serialize)
  end

  private

  def init_actions
    {
      driver: Action.new(who: 'driver', type: 'debit', amount: @price),
      owner: Action.new(who: 'owner', type: 'credit', amount: @price - @commission.total_fees),
      insurance: Action.new(who: 'insurance', type: 'credit', amount: @commission.insurance_fee),
      assistance: Action.new(who: 'assistance', type: 'credit', amount: @commission.assistance_fee),
      drivy: Action.new(who: 'drivy', type: 'credit', amount: @commission.drivy_fee)
    }
  end

  def compute_options
    @options.each do |option|
      send("compute_#{option.type}_option")
    end
  end

  def compute_gps_option
    option_price = 500 * duration
    @actions[:driver].amount += option_price
    @actions[:owner].amount += option_price
  end

  def compute_baby_seat_option
    option_price = 200 * duration
    @actions[:driver].amount += option_price
    @actions[:owner].amount += option_price
  end

  def compute_additional_insurance_option
    option_price = 1000 * duration
    @actions[:driver].amount += option_price
    @actions[:drivy].amount += option_price
  end
end
