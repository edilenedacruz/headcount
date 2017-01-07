require_relative 'test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'
require_relative '../test/fixtures'

class EnrollmentRepositoryTest < Minitest::Test
  def test_it_can_fnd_enrollment_info_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "./fixtures/high_school_graduation_rates_samples.csv"
      }
      })
      enrollment = er.find_by_name("Academy 20")
      assert_equal Enrollment, enrollment.class
  end

  def test_it_returns_nil_if_district_unknown
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./fixtures/Kindergartners_in_full_day_program_sample.csv",
        :high_school_graduation => "./fixtures/high_school_graduation_rates_samples.csv"
      }
      })
      enrollment = er.find_by_name("Ken Lee")
      assert_nil enrollment
  end
end
