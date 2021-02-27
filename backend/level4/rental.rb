require 'date'

class Rental
  attr_reader :id, :car_id, :start_date, :end_date, :distance
  attr_accessor :actions

  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @actions = []

    validate!
  end

  def duration
    (end_date - start_date).to_i + 1
  end

  def serialize
    {
      id: @id,
      actions: @actions.map(&:serialize)
    }
  end

  private

  def validate!
    raise ArgumentError.new, 'id must be an Integer' unless @id.is_a?(Integer)
    raise ArgumentError.new, 'car_id must be an Integer' unless @car_id.is_a?(Integer)
    raise ArgumentError.new, 'distance must be an Integer' unless @distance.is_a?(Integer)
  end
end
