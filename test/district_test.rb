require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test
  attr_reader :d

  def setup
    @d = District.new({:name => "ACADEMY 20"})
  end

  def test_it_can_access_district_by_name
    assert_equal "ACADEMY 20", d.name
  end

  def test_instance_of_district
    assert_instance_of District, d
  end
end
