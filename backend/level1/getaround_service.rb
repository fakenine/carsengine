require './car'
require './rental'

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
  end

  def compute
    @results = @rentals.map do |rental|
      begin
        car = find_car(rental.car_id)
      rescue ArgumentError => e
        puts "Rental #{rental.id} skipped: #{e}"
      end

      {
        id: rental.id,
        price: compute_price(rental, car)
      }
    end
  end

  def serialize
    {
      rentals: @results
    }.to_json
  end

  private

  def find_car(car_id)
    car = @cars.find { |car| car.id == car_id }
    raise ArgumentError.new, "Could not find car for car_id #{car_id}" unless car

    car
  end

  def compute_price(rental, car)
    (car.price_per_day * rental.duration) + (car.price_per_km * rental.distance)
  end
end
