# frozen_string_literal: true

# Override Numeric to calculate percentage of an integer
class Numeric
  def percent_of(num)
    (to_f * num) / 100
  end
end
