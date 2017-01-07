require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  def test_it_can_access_district_repo_and_enrollment_informations
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of District, district
    assert_equal 0.436, district.enrollment.kindergarten_participation_in_year(2010)
  end

  def test_kindergarten_participation_variation_against_state
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.766, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'COLORADO')
  end

  def test_kindergarten_participation_variation_against_another_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_equal 0.447, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'Yuma School District 1')
  end
end
