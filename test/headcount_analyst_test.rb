require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :ha
  def setup
    @dr = DistrictRepository.new
    dr.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    @ha = HeadcountAnalyst.new(dr)
  end

  def test_it_can_access_district_repo_and_enrollment_informations
    district = dr.find_by_name("ACADEMY 20")
    assert_instance_of District, district
    assert_in_delta 0.436, district.enrollment.kindergarten_participation_in_year(2010), 0.005
  end

  def test_kindergarten_participation_variation_against_state
    assert_in_delta 0.766, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'COLORADO'), 0.005
  end

  def test_kindergarten_participation_variation_against_another_district
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('Academy 20', :against => 'Yuma School District 1'), 0.005
  end

  def test_kindergarten_participation_variation_trend
    expected = {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
    assert expected, ha.kindergarten_participation_rate_variation_trend('academy 20', :against => 'COLORADO')
  end

  def test_kindergarten_variation_against_high_school_graduation
    assert_in_delta 0.641, ha.kindergarten_participation_against_high_school_graduation('ACADEMY 20'), 0.005
    assert_in_delta 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J'), 0.005
    assert_in_delta 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2'), 0.005
  end

  def test_kindergarten_participation_predicts_high_school_graduation
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'MONTROSE COUNTY RE-1J')
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'SIERRA GRANDE R-30')
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'PARK (ESTES PARK) R-3')
  end

  def test_kindergarten_participation_predicts_high_school_graduation_against_state
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
  end

  def test_kindergarten_hs_prediction_multi_district
    districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
    assert ha.kindergarten_participation_correlates_with_high_school_graduation(across: districts)
  end
end
