require_relative 'test_helper'
require_relative '../lib/district_repo'
require_relative '../lib/district'

class DistrictRepo < Minitest::Test
  def test_for_destrict_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
  end

end
