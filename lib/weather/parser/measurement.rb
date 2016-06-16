require_relative '../../bigdecimal_ext'

module Weather
  module Parser
    class Measurement
      attr_reader :what, :value, :unit

      def initialize(what, value, unit)
        @what = what.to_sym.freeze
        @value = BigDecimal.new!(value).freeze
        @unit = unit.to_s.freeze
        self.freeze
      end

      def ==(other)
        what == other.what && value == other.value && unit == other.unit
      end
    end
  end
end
