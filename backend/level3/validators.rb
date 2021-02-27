# frozen_string_literal: true

# Validation helpers for classes
module Validators
  def positive_integer!(attr, val)
    raise ArgumentError.new, "#{attr} must be a positive Integer" unless val.is_a?(Integer) && val.positive?
  end

  def valid_date_range!(start_date, end_date)
    raise ArgumentError.new, 'start_date must be before end_date' unless start_date <= end_date
  end
end
