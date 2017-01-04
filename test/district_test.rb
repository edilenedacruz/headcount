require_relative 'test_helper'
require_relative '../lib/district'

class DistrictTest < Minitest::Test

  def test_it_can_access_district_by_name
    d = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", d.name
  end
end
