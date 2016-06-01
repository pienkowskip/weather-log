require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Property.new
    assert_not record.save

    record.text_id = 'wind_speed'
    record.name = '   '
    record.unit = 'm/s'
    assert_not record.save

    record.text_id = 'not valid'
    record.name = 'Wind speed'
    assert_not record.save

    record.text_id = 'wind_speed'
    record.unit = nil
    assert_not record.save

    record.unit = 'm/s'
    assert record.save
  end

  test 'should be uniq' do
    record = Property.new(text_id: 'wind_speed', name: 'Wind speed', unit: 'm/s')
    record.save!

    record = Property.new(text_id: 'wind_speed', name: 'Wind speed', unit: 'm/s')
    assert_not record.save

    record.unit = 'mph'
    assert record.save
  end
end
