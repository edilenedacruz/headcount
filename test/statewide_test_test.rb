require_relative 'test_helper'
require_relative '../lib/statewide_test'
require_relative '../lib/exception_handling'

class StatewideTestTest < Minitest::Test
  attr_reader :str
  def setup
    @str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
  end

  def test_it_access_name
    statewide_test = str.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", statewide_test.name
  end

  def test_it_can_access_proficiency_by_grade_for_third_grade
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
     2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
     2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
     2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
     2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
     2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
     2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
   }
   statewide_test = str.find_by_name("ACADEMY 20")
   assert expected, statewide_test.proficient_by_grade(3)
  end

  def test_it_can_access_proficiency_by_grade_for_eighth_grade
    expected = {2008=>{:math=>0.64, :reading=>0.843, :writing=>0.734}, 2009=>{:math=>0.656, :reading=>0.825, :writing=>0.701}, 2010=>{:math=>0.672, :reading=>0.863, :writing=>0.754}, 2011=>{:reading=>0.832, :math=>0.653, :writing=>0.745}, 2012=>{:math=>0.681, :writing=>0.738, :reading=>0.833}, 2013=>{:math=>0.661, :reading=>0.852, :writing=>0.75}, 2014=>{:math=>0.684, :reading=>0.827, :writing=>0.747}
    }
   statewide_test = str.find_by_name("ACADEMY 20")
   assert expected, statewide_test.proficient_by_grade(8)
  end

  def test_it_can_access_results_by_race
    expected = { 2011 => {math: 0.816, reading: 0.897, writing: 0.826},
     2012 => {math: 0.818, reading: 0.893, writing: 0.808},
     2013 => {math: 0.805, reading: 0.901, writing: 0.810},
     2014 => {math: 0.800, reading: 0.855, writing: 0.789},
   }
    statewide_test = str.find_by_name("ACADEMY 20")
    assert expected, statewide_test.proficient_by_race_or_ethnicity(:asian)
  end

  def test_it_can_access_proficiency_for_subject_by_grade_in_year
    statewide_test = str.find_by_name("ACADEMY 20")
    assert_equal 0.857, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)

    testing = str.find_by_name("ACADEMY 20")
    assert_in_delta 0.653, testing.proficient_for_subject_by_grade_in_year(:math, 8, 2011), 0.005

    testing = str.find_by_name("WRAY SCHOOL DISTRICT RD-2")
    assert_in_delta 0.89, testing.proficient_for_subject_by_grade_in_year(:reading, 3, 2014), 0.005

    testing = str.find_by_name("PLATEAU VALLEY 50")
    assert_equal "N/A", testing.proficient_for_subject_by_grade_in_year(:reading, 8, 2011)
  end

  def test_proficiency_by_subject_race_and_year
    statewide_test = str.find_by_name("ACADEMY 20")
    assert_equal 0.818, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2012)
  end

  def test_unknown_data_errors
    testing = str.find_by_name("AULT-HIGHLAND RE-9")

    assert_raises(UnknownDataError) do
      testing.proficient_by_grade(1)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_grade_in_year(:pizza, 8, 2011)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:reading, :pizza, 2013)
    end

    assert_raises(UnknownDataError) do
      testing.proficient_for_subject_by_race_in_year(:pizza, :white, 2013)
    end
  end

end
