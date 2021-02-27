require './car'
require './rental'
require './numeric'
require './fees_calculator'
require './actions_calculator'

class GetaroundService
  attr_reader :cars, :rentals
  attr_accessor :results

  def initialize(data)
    @cars = data['cars'].map do |car|
      Car.new(id: car['id'], price_per_day: car['price_per_day'], price_per_km: car['price_per_km'])
    end

    @rentals = data['rentals'].map do |rental|
      Rental.new(id: rental['id'], car_id: rental['car_id'], start_date: rental['start_date'],
                 end_date: rental['end_date'], distance: rental['distance'])
    end

    @results = []

    compute
  end

  def compute
    @rentals.map do |rental|
      begin
        car = find_car(rental.car_id)
      rescue ArgumentError => e
        puts "Rental #{rental.id} skipped: #{e}"
      end

      price = price(rental, car)
      commission = FeesCalculator.new(price, rental.duration)
      rental.actions = ActionsCalculator.new(price, commission).actions

      rental
    end
  end

  def serialize
    {
      rentals: @rentals.map(&:serialize)
    }.to_json
  end

  private

  def find_car(car_id)
    car = @cars.find { |car| car.id == car_id }
    raise ArgumentError.new, "Could not find car for car_id #{car_id}" unless car

    car
  end

  def price(rental, car)
    duration_price(rental, car) + distance_price(rental, car)
  end

  def duration_price(rental, car)
    (1..rental.duration).inject(0) do |price, day|
      price + price_per_day_with_discount(car.price_per_day, day).to_i
    end
  end

  def price_per_day_with_discount(price_per_day, day)
    return price_per_day - 50.percent_of(price_per_day) if day > 10
    return price_per_day - 30.percent_of(price_per_day) if day > 4
    return price_per_day - 10.percent_of(price_per_day) if day > 1

    price_per_day
  end

  def distance_price(rental, car)
    (car.price_per_km * rental.distance)
  end
end
