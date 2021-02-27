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

  def price_per_day_with_discount(day)
    if day > 10
      price_per_day - 50.percent_of(price_per_day)
    elsif day > 4
      price_per_day - 30.percent_of(price_per_day)
    elsif day > 1
      price_per_day - 10.percent_of(price_per_day)
    else
      price_per_day
    end.to_i
  end

  private

  def validate!
    positive_integer!(:id, @id)
    positive_integer!(:price_per_day, @price_per_day)
    positive_integer!(:price_per_km, @price_per_km)
  end
end
