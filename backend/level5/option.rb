# frozen_string_literal: true

require './validators'

# Option the user can chose on a rental
class Option
  include Validators

  attr_reader :id, :rental_id, :type

  def initialize(id:, rental_id:, type:)
    @id = id
    @rental_id = rental_id
    @type = type

    validate!
  end

  def price(duration)
    case type
    when 'gps'
      500 * duration
    when 'baby_seat'
      200 * duration
    when 'additional_insurance'
      1000 * duration
    end
  end

  private

  def validate!
    positive_integer!(:id, @id)
    positive_integer!(:rental_id, @rental_id)

    raise ArgumentError, "#{type} is not a valid option" unless %w[gps baby_seat additional_insurance].include?(@type)
  end
end
