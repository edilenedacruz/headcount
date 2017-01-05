require 'csv'
require_relative 'data_parser'
require_relative '../lib/district'


class DistrictRepository
  include DataParser
  attr_reader :districts
  def initialize
    @districts = {}
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

end
