require 'csv'
require_relative '../lib/statewide_test'
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
        fills_third_grade(csv_files, row)
      else
        create(csv_files, row)
      end
    end
  end

  def create(csv_files, row)
    if csv_files[0] == :third_grade
    name = row[:location].upcase
    year = row[:timeframe].to_i
    subject = row[:score].downcase
    data = row[:data].to_s[0..4].to_f
    @statewide_tests[name] = StatewideTest.new( {:name => name, csv_files[0] => {year => {subject => data}}})
    end
  end

  def fills_third_grade(csv_files, row)
    find_by_name(row[:location])
    binding.pry
  end

end
