require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  test 'should validate on save' do
    record = Source.new
    assert_not record.save

    record.text_id = 'ala_ma_kota'
    record.name = '   '
    assert_not record.save

    record.text_id = 'not valid'
    record.name = 'Ala ma kota'
    assert_not record.save

    record.text_id = 'ala_ma_kota'
    assert record.save
  end

  test 'should save JSON config field' do
    record = Source.new(text_id: 'ala_ma_kota', name: 'Ala ma kota')
    record.config = {a: 10, b: 'ala ma kota', c: [1, 2, {d: 'ddd'}]}
    assert record.save
    assert_equal({'c' => [1, 2, {'d' => 'ddd'}], 'b' => 'ala ma kota', 'a' => 10}, record.config)
    record.reload
    assert_equal({'c' => [1, 2, {'d' => 'ddd'}], 'b' => 'ala ma kota', 'a' => 10}, record.config)
  end
end
