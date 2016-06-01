require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Property.new
    assert_not record.save

    record.text_id = 'wind_speed'
    record.name = '   '
    record.unit = 'km/h'
    assert_not record.save

    record.text_id = 'not valid'
    record.name = 'Wind speed'
    assert_not record.save

    record.text_id = 'wind_speed'
    record.unit = nil
    assert_not record.save

    record.unit = 'km/h'
    assert record.save
  end
end
