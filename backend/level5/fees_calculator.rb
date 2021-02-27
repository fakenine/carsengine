require './numeric'

class FeesCalculator
  attr_reader :total_fees, :duration
  attr_accessor :fees_pool, :drivy_fee, :insurance_fee, :assistance_fee

  def initialize(price, duration)
    @total_fees = 30.percent_of(price).to_i
    @fees_pool = @total_fees
    @insurance_fee = 0
    @assistance_fee = 0
    @drivy_fee = 0
    @duration = duration

    compute
  end

  def compute
    compute_insurance_fee
    compute_assistance_fee
    compute_drivy_fee
  end

  def serialize
    {
      insurance_fee: @insurance_fee,
      assistance_fee: @assistance_fee,
      drivy_fee: @drivy_fee
    }
  end

  private

  def compute_insurance_fee
    @insurance_fee = @fees_pool / 2
    @fees_pool -= @insurance_fee
  end

  def compute_assistance_fee
    @assistance_fee = 100 * duration
    @fees_pool -= @assistance_fee
  end

  def compute_drivy_fee
    @drivy_fee = @fees_pool
  end
end
