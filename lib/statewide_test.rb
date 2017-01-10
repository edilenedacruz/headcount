require 'csv'
class StatewideTest
  attr_reader :name, :third_grade
  def initialize(statewide_test_data)
    @name = statewide_test_data[:name].upcase
    @third_grade = statewide_test_data[:third_grade]
  end
end
