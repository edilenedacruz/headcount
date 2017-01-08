require_relative 'test_helper'
require_relative '../lib/enrollment_repository'
require_relative '../lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test
  # attr_reader :er
  # def setup
  #   @er = EnrollmentRepository.new
  #   er.load_data({
  #     :enrollment => {
  #       :kindergarten => "./data/Kindergartners in full-day program.csv",
  #       :high_school_graduation => "./data/High school graduation rates.csv"
  #     }
  #   })
  # end

  def test_it_can_fnd_enrollment_info_by_name
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
      assert_equal Enrollment, enrollment.class
  end

  def test_it_returns_nil_if_district_unknown
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    # enrollment = er.find_by_name("ACADEMY 20")
      enrollment = er.find_by_name("Ken Lee")
      assert_nil enrollment
  end

  def test_it_can_access_graduation_rate_by_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    expected = {2010 => 0.895, 2011 => 0.895, 2012 => 0.889, 2013 => 0.913, 2014 => 0.898}
    assert_equal expected, enrollment.graduation_rate_by_year
  end

  def test_it_can_access_graduation_rate_in_provided_year
    er = EnrollmentRepository.new
    er.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    })
    enrollment = er.find_by_name("ACADEMY 20")
    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
  end
end
