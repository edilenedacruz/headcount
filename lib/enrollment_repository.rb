# require 'pry'
#
# class EnrollmentRepository
#   attr_reader :enrollments
#   def initialize(name = nil)
#     @enrollments = {}
#   end
#
#   def load_data(files)
#     kindergarten_files = files[:enrollment][:kindergarten]
#     high_school_files = files[:enrollment][:high_school_graduation]
#     create_kindergarten(kindergarten_files)
#     add_high_school_data(high_school_files)
#   end
#
#   def create_kindergarten(kindergarten_files)
#     contents = (CSV.open kindergarten_files, headers: true, header_converters: :symbol)
#     year = []
#     data = []
#     contents.map do |row|
#       name = row[:location].upcase
#       year << row[:timeframe].to_i
#       data << (row[:data].to_f * 1000 / 1000.0).to_s[0..4].to_f
#       year_data_hash = year.zip(data).to_h
#       @enrollments[name.upcase] = Enrollment.new({:name => name, :kindergarten_participation => year_data_hash, :high_school_graduation => {}})
#     end
#   end
#
#   def add_high_school_data(high_school_files)
#     contents = (CSV.open high_school_files, headers: true, header_converters: :symbol)
#       contents.map do |row|
#         name = row[:location].upcase
#         year = row[:timeframe].to_i
#         data = (row[:data].to_f * 1000 / 1000.0).to_s[0..4].to_f
#         @enrollments[name].high_school_graduation[year] = data
#         end
#   end
#
#   def find_by_name(name)
#     @enrollments[name.upcase]
#   end
#
# end
#
#
#


require 'csv'
require_relative '../lib/enrollment'
require_relative 'data_parser'
require 'pry'

class EnrollmentRepository
  include DataParser
  attr_reader :enrollments
  def initialize
    @enrollments = {}
  end

  def load_data(files)
    kinder_files = DataParser.parse(files[:enrollment])
    kinder_files.map do |csv_files|
      build_enrollments(csv_files)
    end
  end

  def build_enrollments(csv_files)
    csv_files[1].map do |row|
      if find_by_name(row[:location].upcase)
        fill(csv_files, row)
      else
        create(csv_files, row)
      end
    end
  end


    def fill(csv_files, row)
      e = find_by_name(row[:location])
      attribute = csv_files[0]
      year = row[:timeframe].to_i
      data = row[:data].to_s[0..4].to_f
      e.send(attribute)[year] = data
    end

    def create(csv_files, row)
      name = row[:location].upcase
      year = row[:timeframe].to_i
      data = row[:data].to_s[0..4].to_f
      @enrollments[name] = Enrollment.new( {:name => name, csv_files[0] => {year => data}})
      # binding.pry
    end

    def find_by_name(name)
      @enrollments[name.upcase]
    end
  end
