require 'bigdecimal'

def BigDecimal.new!(value, *digit)
  Float(value)
  BigDecimal.new(value, *digit)
end