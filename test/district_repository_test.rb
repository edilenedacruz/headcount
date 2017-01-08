
require_relative 'test_helper'
require_relative '../lib/district_repository'
require_relative '../lib/district'

class DistrictRepo < Minitest::Test
  def test_for_destrict_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    district = dr.find_by_name("COLORADO")
    assert_instance_of District, district
  end

  def test_it_can_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal district, dr.find_by_name("ACADEMY 20")
  end

  def test_it_returns_nil_if_district_unknown
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert_nil dr.find_by_name("Jamaica")
  end

  def test_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })

    assert_equal 19, dr.find_all_matching("ar").count
  end

  def test_it_creates_enrollment_repository
    dr = DistrictRepository.new
    dr.load_data({
    :enrollment => {
      :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
    })
    district = dr.find_by_name("Academy 20")
    assert_instance_of District, district
    assert_equal "ACADEMY 20", district.enrollment.name
    assert_in_delta 0.436, district.enrollment.kindergarten_participation_in_year(2010), 0.005
  end
end
