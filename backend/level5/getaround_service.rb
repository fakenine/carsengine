# frozen_string_literal: true

require './car'
require './rental'
require './numeric'
require './fees_calculator'
require './actions_calculator'
require './option'

# Getaround service used to compute rentals for users
class GetaroundService
  attr_reader :cars, :rentals
  attr_accessor :results

  def initialize(data)
    @cars = init_cars(data)
    @rentals = init_rentals(data)
    @options = init_options(data)
  end

  def compute
    @rentals.each do |rental|
      begin
        car = find_car(rental.car_id)
      rescue ArgumentError => e
        puts "Rental #{rental.id} skipped: #{e}"
      end

      compute_rental(rental, car)
    end
  end

  def serialize
    {
      rentals: @rentals.map(&:serialize)
    }
  end

  private

  def init_cars(data)
    data['cars'].map do |car|
      Car.new(id: car['id'], price_per_day: car['price_per_day'], price_per_km: car['price_per_km'])
    end
  end

  def init_rentals(data)
    data['rentals'].map do |rental|
      Rental.new(id: rental['id'], car_id: rental['car_id'], start_date: rental['start_date'],
                 end_date: rental['end_date'], distance: rental['distance'])
    end
  end

  def init_options(data)
    data['options'].map do |option|
      Option.new(id: option['id'], rental_id: option['rental_id'], type: option['type'])
    end
  end

  def find_car(car_id)
    res = @cars.find { |car| car.id == car_id }
    raise ArgumentError.new, "Could not find car for car_id #{car_id}" unless res

    res
  end

  def find_options(rental_id)
    @options.select { |option| option.rental_id == rental_id }
  end

  def compute_rental_price(rental, car)
    duration_price(rental, car) + distance_price(rental, car)
  end

  def duration_price(rental, car)
    (1..rental.duration).inject(0) do |price, day|
      price + car.price_per_day_with_discount(day)
    end
  end

  def distance_price(rental, car)
    (car.price_per_km * rental.distance)
  end

  def compute_rental(rental, car)
    rental.price = compute_rental_price(rental, car)
    rental.commission = FeesCalculator.new(rental.price, rental.duration)
    rental.options = find_options(rental.id)
    rental.actions = ActionsCalculator.new(rental.price, rental.commission, rental.duration, rental.options).actions
  end
end
