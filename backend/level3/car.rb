class Car
  attr_reader :id, :price_per_day, :price_per_km

  def initialize(id:, price_per_day:, price_per_km:)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km

    validate!
  end

  private

  def validate!
    raise ArgumentError.new, 'id must be an Integer' unless @id.is_a?(Integer)
    raise ArgumentError.new, 'price_per_day must be an Integer' unless @price_per_day.is_a?(Integer)
    raise ArgumentError.new, 'price_per_km must be an Integer' unless @price_per_km.is_a?(Integer)
  end
end
