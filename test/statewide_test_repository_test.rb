require_relative 'test_helper'
require 'csv'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/data_parser'

class StatewideTestRepositoryTest < Minitest::Test

  def test_it_can_access_instance_of_statewide_test
    str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
        :third_grade => "test/fixtures/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "test/fixtures/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "test/fixtures/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
      })
    statewide = str.find_by_name("ACADEMY 20")
    assert_instance_of StatewideTest, statewide
  end

end
