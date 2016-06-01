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

    record.property = properties(:wind_speed)
    assert record.save
  end

  test 'should be uniq' do
    record = Series.new(source: sources(:meteoblue), location: locations(:rysy), property: properties(:temperature))
    record.save!

    record = Series.new(source: sources(:meteoblue), location: locations(:rysy), property: properties(:temperature))
    assert_not record.save

    record.property = properties(:wind_speed)
    assert record.save
  end
end
