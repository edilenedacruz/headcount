require 'csv'

class Enrollment
  attr_reader :name, :kindergarten_participation, :parent
  def initialize(enrollment_data, parent = nil)
    @name = enrollment_data[:name].upcase
    @kindergarten_participation = enrollment_data[:kindergarten_participation]
    @parent = parent
  end

  def kindergarten_participation_by_year
    kindergarten_participation
  end

  def kindergarten_participation_in_year(year)
    kindergarten_participation[year]
  end
end
