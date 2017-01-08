require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  def test_it_can_access_district_repo_and_enrollment_informations
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of District, district
    assert_in_delta 0.436, district.enrollment.kindergarten_participation_in_year(2010), 0.005
  end

  def test_kindergarten_participation_variation_against_state
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.766, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'COLORADO'), 0.005
  end

  def test_kindergarten_participation_variation_against_another_district
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'Yuma School District 1'), 0.005
  end

  def test_kindergarten_participation_variation_trend
    dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    ha = HeadcountAnalyst.new(dr)
    expected = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
    assert expected, ha.kindergarten_participation_rate_variation_trend('academy 20', :against => 'COLORADO')
  end
end
