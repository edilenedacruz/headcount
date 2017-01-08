require_relative 'test_helper'
require_relative '../lib/data_parser'

class DataParserTest < Minitest::Test
  include DataParser
  def test_it_can_access_csv_file
    filename = {
      :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
      :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
    }
    assert_instance_of Array, parse(filename)
  end

  def test_it_can_access_csv_file_by_header
    filename = {
      :kindergarten => "test/fixtures/Kindergartners_in_full_day_program_sample.csv",
      :high_school_graduation => "test/fixtures/high_school_graduation_rates_samples.csv"
    }
    assert_instance_of CSV, parse(filename).first.last
  end
end
