require 'csv'
require_relative '../lib/statewide_test_repository'

class StatewideTest
  attr_reader :name, :third_grade, :eighth_grade, :math, :reading, :writing

  def initialize(statewide_test_data)
    @name = statewide_test_data[:name].upcase
    @third_grade = statewide_test_data[:third_grade] || {}
    @eighth_grade = statewide_test_data[:eighth_grade] || {}
    @math = statewide_test_data[:math] || {}
    @reading = statewide_test_data[:reading] || {}
    @writing = statewide_test_data[:writing] || {}
  end

  # def proficient_by_grade(grade)
  #
  # end
  #
  # def proficient_by_race_or_ethnicity(race)
  #
  # end
  #
  # def proficient_for_subject_by_grade_in_year(subject, grade, year)
  #
  # end
  #
  # def proficient_for_subject_by_race_in_year(subject, race, year)
  #
  # end


end
