require_relative 'test_helper'
require_relative '../lib/district_repository'
require_relative '../lib/district'

class DistrictRepo < Minitest::Test
  def test_for_destrict_repository
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
      }
    })

    district = dr.find_by_name("COLORADO")
    assert_instance_of District, district
  end

  def test_it_can_find_by_name
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
      }
    })
    district = dr.find_by_name("ACADEMY 20")
    assert_equal district, dr.find_by_name("ACADEMY 20")
  end

  def test_it_returns_nil_if_district_unknown
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
      }
    })

    assert_nil dr.find_by_name("Jamaica")
  end

  def test_can_find_all_matching
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
      }
    })

    assert_equal 19, dr.find_all_matching("ar").count
  end
end
