require 'csv'
require_relative '../lib/data_parser'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district'
require_relative '../lib/statewide_test_repository'
require_relative '../lib/statewide_test'
require_relative '../lib/economic_profile_repository'
require_relative '../lib/economic_profile'


class DistrictRepository
  include DataParser
  attr_reader :districts, :enrollment_repo, :statewide_test_repo, :economic_profile_repo
  def initialize
    @districts = {}
    @enrollment_repo = EnrollmentRepository.new
    @statewide_test_repo = StatewideTestRepository.new
    @economic_profile_repo = EconomicProfileRepository.new
  end

  def load_data(files)
    csv_files = DataParser.parse(files[:enrollment])
    dr_repo(csv_files[0])
    @enrollment_repo.load_data(files) if files[:enrollment]
    @statewide_test_repo.load_data(files) if files[:statewide_testing]
  end

  def dr_repo(csv_file)

    kinder_data = csv_file[1]
    kinder_data.map do |row|
      name = row[:location].upcase
      @districts[name] = District.new({:name => name}, self) if !find_by_name(name)
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

  def connect_with_enrollment(name)
    enrollment_repo.enrollments[name.upcase]
  end

  def connect_with_statewide_test(name)
    statewide_test_repo.statewide_tests[name.upcase]
  end

  def connect_with_economic_profile(name)
    economic_profile_repo.economic_profiles[name.upcase]
  end

end
