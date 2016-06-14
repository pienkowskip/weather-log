require 'test_helper'

module Weather
  module Parser
    class ToprTest < ActiveSupport::TestCase
      def setup
        @timestamp = '20160404201633'
        @parser = Topr.new
      end

      test 'should parse XML' do
        [
            [:morskie_oko, '2016-04-04 20:10:00', [:temperature, '8.9', '°C'], [:wind_speed, '3.8833333333333333', 'm/s'], [:wind_direction, 224, '°']],
            [:kasprowy_wierch, @timestamp, [:temperature, '4.9', '°C']],
            [:piec_stawow, '2016-04-04 20:10:00', [:temperature, '7.1', '°C'], [:wind_speed, '2.2166666666666663', 'm/s'], [:wind_direction, '239.1667', '°']]
        ].each do |location_id, exp_fetched_at, *exp_result|
          fetched_at, result = @parser.parse(Time.parse(@timestamp), file_fixture("snapshots/topr-#{location_id}-#{@timestamp}.xml").read)
          assert_equal Time.parse(exp_fetched_at), fetched_at
          exp_result.map! { |i| Measurement.new(*i) }.sort_by!(&:what)
          assert_equal exp_result, result.sort_by(&:what)
        end
      end
    end
  end
end