require_relative 'test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test
  def test_it_can_fnd_enrollment_info_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      enrollment = er.find_by_name("Academy 20")
      assert_equal Enrollment, enrollment.class
  end

  def test_it_returns_nil_if_district_unknown
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      }
      })
      enrollment = er.find_by_name("Ken Lee")
      assert_nil enrollment
  end
end
