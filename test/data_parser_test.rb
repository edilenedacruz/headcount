require_relative 'test_helper'
require_relative '../lib/data_parser'
require_relative '../test/fixtures'

class DataParserTest < Minitest::Test
  include DataParser
  def test_it_can_access_csv_file
    filename = {
      :kindergarten => "./fixtures/Kindergartners_in_full_day_program_sample.csv",
      :high_school_graduation => "./fixtures/high_school_graduation_rates_samples.csv"
    }
    assert_instance_of Array, parse(filename)
  end

  def test_it_can_access_csv_file_by_header
    filename = {
      :kindergarten => "./fixtures/Kindergartners_in_full_day_program_sample.csv",
      :high_school_graduation => "./fixtures/high_school_graduation_rates_samples.csv"
    }
    assert_instance_of CSV, parse(filename).first.last
  end
end
