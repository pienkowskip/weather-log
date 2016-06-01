require 'test_helper'

class SeriesTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Series.new
    assert_not record.save

    record.source = Source.new
    record.location = Location.new
    record.property = Property.new
    assert_not record.save

    record.source = sources(:topr)
    assert_not record.save

    record.location = locations(:rysy)
    assert_not record.save

    record.property = properties(:temperature)
    assert record.save
  end
end
