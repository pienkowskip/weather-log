require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Measurement.new
    assert_not record.save

    record.series = Series.new
    record.snapshot = Snapshot.new
    record.created_at = Time.now
    record.value = 10
    assert_not record.save

    record.series = series(:first)
    assert_not record.save

    record.snapshot = snapshots(:first)
    assert record.save

    record.created_at = nil
    assert_not record.save

    record.created_at = Time.now
    record.value = 'not valid number'
    assert_not record.save

    record.value = '10.9'
    assert record.save

    assert_equal BigDecimal.new!('10.9'), record.value
  end

  test 'should be uniq' do
    record = Measurement.new(series: series(:first), snapshot: snapshots(:first), created_at: Time.at(0), value: 10)
    record.save!

    record = Measurement.new(series: series(:first), snapshot: snapshots(:first), created_at: Time.at(0), value: 20)
    assert_not record.save

    record.created_at = Time.at(1)
    assert record.save
  end
end
