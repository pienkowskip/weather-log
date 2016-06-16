require 'test_helper'

class BigDecimalExtTest < ActiveSupport::TestCase
  test 'should raise exceptions' do
    assert_equal 1, BigDecimal.new!(1)
    assert_equal BigDecimal.new('1.1'), BigDecimal.new!(1.1, 2)

    assert_equal 1, BigDecimal.new!('  1  ')
    assert_equal 11, BigDecimal.new!('  011  ')
    assert_equal BigDecimal.new('1.1'), BigDecimal.new!('  1.1  ')

    assert_raises(ArgumentError) { BigDecimal.new!('  1   xx') }
    assert_raises(ArgumentError) { BigDecimal.new!('  1.1  xx') }

    assert_raises(ArgumentError) {BigDecimal.new!('xx  1  ')}
    assert_raises(ArgumentError) {BigDecimal.new!('xx  1.1  ')}

    assert_raises(ArgumentError) {BigDecimal.new!('xx')}
    assert_raises(ArgumentError) {BigDecimal.new!('ff')}
    assert_raises(ArgumentError) {BigDecimal.new!('  ')}

    assert_equal 0, BigDecimal.new!('0xff') # kind of a bug

    assert_raises(TypeError) { BigDecimal.new!(nil) }
  end

  test 'should convert to 0' do
    assert_equal 1, BigDecimal.new(1)
    assert_equal BigDecimal.new('1.1'), BigDecimal.new(1.1, 2)

    assert_equal 1, BigDecimal.new('  1  ')
    assert_equal 11, BigDecimal.new('  011  ')
    assert_equal BigDecimal.new('1.1'), BigDecimal.new('  1.1  ')

    assert_equal 1, BigDecimal.new('  1   xx')
    assert_equal BigDecimal.new('1.1'), BigDecimal.new('  1.1  xx')

    assert_equal 0, BigDecimal.new('xx  1  ')
    assert_equal 0, BigDecimal.new('xx  1.1  ')

    assert_equal 0, BigDecimal.new('xx')
    assert_equal 0, BigDecimal.new('ff')
    assert_equal 0, BigDecimal.new('  ')

    assert_equal 0, BigDecimal.new('0xff')

    assert_raises(TypeError) { BigDecimal.new(nil) }
  end
end