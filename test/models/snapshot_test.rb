require 'test_helper'

class SnapshotTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Snapshot.new
    assert_not record.save

    record.status = :invalid
    record.created_at = Time.now
    record.source = sources(:topr)
    record.location = locations(:rysy)
    assert_not record.save

    record.status = :created
    record.created_at = 'ala ma kota'
    assert_not record.save

    record.created_at = nil
    assert_not record.save

    record.created_at = Time.now
    record.source = nil
    assert_not record.save

    record.source = Source.new
    assert_not record.save

    record.source = sources(:topr)
    record.location = nil
    assert_not record.save

    record.location = Location.new
    assert_not record.save

    record.location = locations(:rysy)
    assert record.save

    record.media_type = 'text/plain'
    record.file = 'ala ma kota'
    record.error = 'some exception'
    assert record.save
  end
end
