require_relative 'test_helper'
require_relative '../lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  attr_reader :str
  def setup
    @str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_it_can_access_instance_of_statewide_test
    statewide = str.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", statewide
    # assert_instance_of StatewideTest, statewide
  end

end
