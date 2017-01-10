require_relative 'test_helper'
require_relative '../lib/statewide_test'

class StatewideTestTest < Minitest::Test
  # attr_reader :str
  # def setup
  #   @str = StatewideTestRepository.new
  #   str.load_data({
  #     :statewide_testing => {
  #       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #     }
  #   })
  #   str = str.find_by_name("ACADEMY 20")
  # end

  def test_it_can_create_instance
    data = ({
        :statewide_testing => {
          :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
          :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
          :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
          :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
          :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
        }
      })
    statewide_test = StatewideTest.new(data)
    assert_equal
  end
end
