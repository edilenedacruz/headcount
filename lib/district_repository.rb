require 'csv'
require_relative '../lib/district'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'


class DistrictRepository
  attr_reader :districts, :enrollment
  def initialize(parent = nil)
    @districts = {}
    @enrollment = EnrollmentRepository.new
  end

  def load_data(files)
    filename = files[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    contents.map do |row|
      name = row[:location].upcase
      @districts[name] = District.new({:name => name})
    end
  end

  def find_by_name(name)
    @districts[name.upcase]
  end

  def find_all_matching(fragment)
    @districts.find_all do |district|
      district[0].include?(fragment.upcase)
    end
  end

  # def connect_with_enrollment(name)
  #   binding.pry
  #   enrollment.enrollments[name]
  # end

end
