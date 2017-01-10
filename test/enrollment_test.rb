require_relative 'test_helper'
require_relative '../lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :e
  def setup
    @e = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  end

  def test_it_can_access_district_name
    assert_equal "ACADEMY 20", e.name
  end

  def test_it_can_access_kindergarten_participation_hash_data
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_it_can_access_kindergarten_participation_by_year
    expected = {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
    assert_equal expected, e.kindergarten_participation_by_year
  end

  def test_it_can_access_kindergarten_participation_in_year_provided
    assert_in_delta 0.391, e.kindergarten_participation_in_year(2010), 0.005
  end
end
