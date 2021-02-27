# frozen_string_literal: true

require 'date'
require './validators'

# Rentals created by users to rent cars
class Rental
  include Validators

  attr_reader :id, :car_id, :start_date, :end_date, :distance
  attr_accessor :price

  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @price = 0

    validate!
  end

  # Returns the duration of the rental in days
  def duration
    (end_date - start_date).to_i + 1
  end

  def serialize
    {
      id: @id,
      price: @price
    }
  end

  private

  def validate!
    positive_integer!(:id, @id)
    positive_integer!(:car_id, @car_id)
    positive_integer!(:distance, @distance)
    valid_date_range!(@start_date, @end_date)
  end
end
