require 'test_helper'

class SourceTest < ActiveSupport::TestCase
  test 'should validate on save' do
    source = Source.new

    assert_not source.save

    source.text_id = 'ala_ma_kota'
    source.name = '   '
    assert_not source.save

    source.text_id = 'not valid'
    source.name = 'Ala ma kota'
    assert_not source.save

    source.text_id = 'ala_ma_kota'
    assert source.save
  end

  test 'should save JSON config field' do
    source = Source.new text_id: 'ala_ma_kota', name: 'Ala ma kota'
    source.config = {a: 10, b: 'ala ma kota', c: [1, 2, {d: 'ddd'}]}
    assert source.save
    assert_equal({'c' => [1, 2, {'d' => 'ddd'}], 'b' => 'ala ma kota', 'a' => 10}, source.config)
    source.reload
    assert_equal({'c' => [1, 2, {'d' => 'ddd'}], 'b' => 'ala ma kota', 'a' => 10}, source.config)
  end
end
