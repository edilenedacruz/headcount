require 'csv'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/exception_handling'

class StatewideTest
  attr_reader :name, :third_grade, :eighth_grade, :math, :reading, :writing

  GRADES = [3, 8]
  RACES = [:asian, :black, :pacific_islander, :hispanic, :native_american, :two_or_more, :white]
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
    # raise UnknownDataError unless GRADES.include?(grade)
    return third_grade if grade == 3
    return eighth_grade if grade == 8
  end

  def proficient_by_race_or_ethnicity(race)
    #raise UnknownRaceError unless RACES.include?(race)
    race_proficiency = {}
    math_proficiency_for_race(race, race_proficiency)
    reading_proficiency_for_race(race, race_proficiency)
    writing_proficiency_for_race(race, race_proficiency)
    race_proficiency
  end

  def math_proficiency_for_race(race, race_proficiency)
    @math.map do |year, data|
      race_proficiency[year] = {:math => data[race]}
    end
  end

  def reading_proficiency_for_race(race, race_proficiency)
    @reading.map do |year, data|
      race_proficiency[year].store(:reading, data[race])
    end
  end

  def writing_proficiency_for_race(race, race_proficiency)
    @writing.map do |year, data|
    race_proficiency[year].store(:writing, data[race])
    end
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    # raise UnknownDataError unless SUBJECT.include?(subject)
    # raise UnknownDataError unless GRADES.include?(grade)
    subj = subject.downcase.to_sym
    yr = year.to_i
    if grade == 3
      gr = third_grade
    else
      gr = eighth_grade
    end
  gr[year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    # raise UnknownDataError unless SUBJECT.include?(subject)
    subj = subject.downcase.to_sym
    rc = race.downcase.to_sym
    yr = year.to_i
    proficient_by_race_or_ethnicity(race)[yr][subj]
  end


end
