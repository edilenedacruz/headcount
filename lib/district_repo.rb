require 'csv'
require_relative 'data_parser'
require_relative '../lib/district'


class DistrictRepository
  include DataParser
  def load_data(filename)
    binding.pry
    parse(filename).map do |name|
      district_data[:name]
    binding.pry
  end
  end
end
