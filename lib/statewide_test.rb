require 'csv'
require_relative '../lib/exception_handling'

class StatewideTest
  attr_reader :name,
              :third_grade,
              :eighth_grade,
              :math,
              :reading,
              :writing

  GRADES = [3, 8]
  RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american,
    :two_or_more, :white]
  SUBJECT = [:math, :writing, :reading]

  def initialize(statewide_test_data)
    @name = statewide_test_data[:name].upcase
    @third_grade = statewide_test_data[:third_grade] || {}
    @eighth_grade = statewide_test_data[:eighth_grade] || {}
    @math = statewide_test_data[:math] || {}
    @reading = statewide_test_data[:reading] || {}
    @writing = statewide_test_data[:writing] || {}
  end

  def proficient_by_grade(grade)
    raise UnknownDataError unless GRADES.include?(grade)
    return third_grade if grade == 3
    return eighth_grade if grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    raise UnknownDataError unless RACES.include?(race)
    race_proficiency = {}
    math_proficiency_for_race(race, race_proficiency)
    reading_proficiency_for_race(race, race_proficiency)
    writing_proficiency_for_race(race, race_proficiency)
    race_proficiency
  end

  def math_proficiency_for_race(race, race_proficiency)
    @math.map { |yr, data| race_proficiency[yr] = {:math => data[race]} }
  end

  def reading_proficiency_for_race(race, race_proficiency)
    @reading.map { |yr, data| race_proficiency[yr].store(:reading, data[race]) }
  end

  def writing_proficiency_for_race(race, race_proficiency)
    @writing.map { |yr, data| race_proficiency[yr].store(:writing, data[race]) }
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    raise UnknownDataError unless SUBJECT.include?(subject)
    raise UnknownDataError unless GRADES.include?(grade)
      if grade == 3
        grade = third_grade
      else
        grade = eighth_grade
      end
      return "N/A" if grade[year][subject] == 0.0
      grade[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    raise UnknownDataError unless SUBJECT.include?(subject)
    proficient_by_race_or_ethnicity(race)[year][subject]
  end


end
