
require_relative 'test_helper'
require_relative '../lib/district'
require_relative '../lib/district_repository'
require_relative '../lib/enrollment_repository'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'

class DistrictRepo < Minitest::Test
  attr_reader :dr
  def setup
    @dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
      })
  end

  def test_for_destrict_repository
    district = dr.find_by_name("COLORADO")
    assert_instance_of District, district
  end

  def test_it_can_find_by_name
    district = dr.find_by_name("ACADEMY 20")
    assert_equal district, dr.find_by_name("ACADEMY 20")
  end

  def test_it_returns_nil_if_district_unknown
    assert_nil dr.find_by_name("Jamaica")
  end

  def test_can_find_all_matching
    assert_equal 19, dr.find_all_matching("ar").count
  end

  def test_it_creates_enrollment_repository
    district = dr.find_by_name("Academy 20")
    assert_instance_of District, district
    assert_equal "ACADEMY 20", district.enrollment.name
    assert_in_delta 0.436, district.enrollment.kindergarten_participation_in_year(2010), 0.005
  end

  def test_statewide_testing_relationships
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    statewide_test = district.statewide_test
    assert_equal "ACADEMY 20", district.statewide_test.name
    assert statewide_test.is_a?(StatewideTest)
  end
end
