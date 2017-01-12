require_relative 'test_helper'
require_relative '../lib/data_parser'

class DataParserTest < Minitest::Test
  include DataParser
  def test_it_can_access_csv_file
    filename = ({
      :kindergarten => "test/fixtures/Kindergartners in full-day program.csv",
      :high_school_graduation => "test/fixtures/High school graduation rates.csv",
    })
    assert_instance_of Array, DataParser.parse(filename)
  end

  def test_it_can_access_csv_file_by_header
    filename = ({
      :kindergarten => "test/fixtures/Kindergartners in full-day program.csv",
      :high_school_graduation => "test/fixtures/High school graduation rates.csv",
    })
    assert_instance_of CSV, DataParser.parse(filename).first.last
  end
end
