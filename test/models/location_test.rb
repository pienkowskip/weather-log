require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Location.new
    assert_not record.save

    record.text_id = 'ala_ma_kota'
    record.name = '   '
    assert_not record.save

    record.text_id = 'not valid'
    record.name = 'Ala ma kota'
    assert_not record.save

    record.text_id = 'ala_ma_kota'
    assert record.save

    record.latitude = 'not valid number'
    record.elevation = 0
    assert_not record.save

    record.latitude = -20.088333
    record.elevation = '2500.75'
    assert record.save

    assert_equal BigDecimal('-20.088333'), record.latitude
    assert_equal BigDecimal('2500.75'), record.elevation
  end
end
