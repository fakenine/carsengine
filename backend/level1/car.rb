# frozen_string_literal: true

require './validators'

# Cars that users can rent
class Car
  include Validators

  attr_reader :id, :price_per_day, :price_per_km

  def initialize(id:, price_per_day:, price_per_km:)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km

    validate!
  end

  private

  def validate!
    positive_integer!(:id, @id)
    positive_integer!(:price_per_day, @price_per_day)
    positive_integer!(:price_per_km, @price_per_km)
  end
end
