require 'test_helper'

module Weather
  module Fetcher
    class ToprTest < ActiveSupport::TestCase
      def setup
        @timestamp = '20160404201633'
        @fetcher = Topr.new
        Wget.any_instance.stubs(:fetch).returns([Time.parse(@timestamp), file_fixture("snapshots/topr-#{@timestamp}.xml").read])
      end

      test 'should extract one location part of XML' do
        [:morskie_oko, :piec_stawow, :kasprowy_wierch].each do |location_id|
          location = locations(location_id)
          fetched_at, file = @fetcher.fetch(location, nil)
          assert_equal Time.parse(@timestamp), fetched_at
          assert_equal file_fixture("snapshots/topr-#{location_id}-#{@timestamp}.xml").read, file
        end
      end

      test 'should raise on unknow location' do
        location = locations(:rysy)
        error = assert_raises(FetchingError) { @fetcher.fetch(location, nil) }
        assert_equal 'Location not supported.', error.message
      end
    end
  end
end