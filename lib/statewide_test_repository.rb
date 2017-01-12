require 'csv'
require_relative 'data_parser'

class StatewideTestRepository
  include DataParser
  attr_reader :statewide_tests

  def initialize
    @statewide_tests = {}
  end

  def load_data(files)
    state_testing_files = DataParser.parse(files[:statewide_testing])
    state_testing_files.map do |csv_files|
      build_statewide(csv_files)
    end
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end

  def build_statewide(csv_files)
    csv_files[1].map do |row|
      if find_by_name(row[:location].upcase)
        fills_repo(csv_files, row)
      else
        create(csv_files, row)
      end
    end
  end

  def create(csv_files, row)
    score_or_race = row[:score] || row[:race_ethnicity] || 'blank'
    year = row[:timeframe].to_i
    subject = score_or_race.downcase.to_sym
    data = row[:data].to_s[0..4].to_f
    name = row[:location].upcase
    @statewide_tests[name] = StatewideTest.new( {:name => name,
      csv_files[0] => {year => {subject => data}}})
  end

  def fills_repo(csv_files, row)
    attribute = csv_files[0]
    build_grade_test_hash(row, attribute)
  end

  def build_grade_test_hash(row, attribute)
    swt = find_by_name(row[:location].upcase)
    score_or_race = row[:score] || row[:race_ethnicity] || 'blank'
    if !swt.send(attribute)[row[:timeframe].to_i].nil?
      fill_year_key(row, attribute, swt, score_or_race)
    else
      create_year_key(row, attribute, swt, score_or_race)
    end
  end

  def fill_year_key(row, attribute, swt, score_or_race)
    year = row[:timeframe].to_i
    subject = score_or_race.downcase.to_sym
    data = row[:data].to_s[0..4].to_f
    swt.send(attribute)[year].store(subject, data)
  end

  def create_year_key(row, attribute, swt, score_or_race)
    year = row[:timeframe].to_i
    subject = score_or_race.downcase.to_sym
    data = row[:data].to_s[0..4].to_f
    swt.send(attribute)[year] = {subject => data}
  end

end
