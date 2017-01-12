require 'csv'
require_relative '../lib/economic_profile'
require_relative '../lib/data_parser'

class EconomicProfileRepository
  include DataParser
  attr_reader :economic_profiles

  def initialize
    @economic_profiles = {}
  end

  def load_data(files)
    economic_files = DataParser.parse(files[:economic_profile])
    economic_files.map do |csv_files|
      build_economic_profile(csv_files)
    end
  end

  def find_by_name(name)
    @economic_profiles[name.upcase]
  end

  private

  def build_economic_profile(csv_files)
    csv_files[1].map do |row|
      if find_by_name(row[:location])
         fill_this_economic_profile(csv_files, row)
      else
        create_new_economic_profile(csv_files, row)
      end
    end
  end

  def fill_this_economic_profile(csv_files, row)
    attribute = csv_files[0]
    data = row[:data].to_s[0..4].to_f
    if attribute == :median_household_income
      fill_median_household_income(row)
    elsif attribute == :free_or_reduced_price_lunch
      fill_free_or_reduced_price_lunch(row)
    else
      ep = find_by_name(row[:location])
      ep.send(attribute)[row[:timeframe].to_i] = data
    end
  end

  def fill_median_household_income(row)
    attribute = :median_household_income
    data = row[:data].to_s[0..4].to_f
    year = convert_date_range(row[:timeframe])
    ep = find_by_name(row[:location])
    ep.send(attribute)[year] = data
  end

  def fill_free_or_reduced_price_lunch(row)
    year = row[:timeframe].to_i
    attribute = :free_or_reduced_price_lunch
    string = "Eligible for Free or Reduced Lunch"
    row[:poverty_level] == string ? percent_or_number(row,year,attribute) : nil
  end

  def percent_or_number(row, year, attribute)
    if row[:dataformat] == "Percent"
      fill_free_or_reduced_price_lunch_with_percent(row, year, attribute)
    elsif row[:dataformat] == "Number"
      fill_free_or_reduced_price_lunch_with_number(row, year, attribute)
    end
  end

  def fill_free_or_reduced_price_lunch_with_percent(row, year, attribute)
    data = row[:data].to_s[0..4].to_f
    ep = find_by_name(row[:location])
    if ep.send(attribute)[year].nil?
      ep.send(attribute)[year] = {:percentage => data}
    else
      ep.send(attribute)[year].store(:percentage, data)
    end
  end

  def fill_free_or_reduced_price_lunch_with_number(row, year, attribute)
    ep = find_by_name(row[:location])
    if ep.send(attribute)[year].nil?
      ep.send(attribute)[year] = {:total => row[:data].to_i}
    else
      ep.send(attribute)[year].store(:total, row[:data].to_i)
    end
  end

  def create_new_economic_profile(csv_files, row)
    attribute = csv_files[0]
    year = median_household_income_or_else(row, attribute)
    data = row[:data].to_s[0..4].to_f
    @economic_profiles[row[:location].upcase] = EconomicProfile.new( {
      :name => row[:location].upcase, attribute=>{year=>data}})
  end

  def median_household_income_or_else(row, attribute)
    if attribute == :median_household_income
      year = convert_date_range(row[:timeframe])
    else
      year = row[:timeframe].to_i
    end
  end

    def convert_date_range(year_range)
      year_range.split("-").map { |year| year.to_i }
    end
end









# require 'csv'
# require_relative '../lib/economic_profile'
# require_relative '../lib/data_parser'
#
# class EconomicProfileRepository
#   include DataParser
#   attr_reader :economic_profiles
#   def initialize
#     @economic_profiles = {}
#   end
#
#   def load_data(files)
#     economic_files = DataParser.parse(files[:economic_profile])
#     economic_files.map do |csv_files|
#       build_economic_profile(csv_files)
#     end
#   end
#
#   def find_by_name(name)
#     @economic_profiles[name.upcase]
#   end
#
#   def build_economic_profile(csv_files)
#     csv_files[1].map do |row|
#       if find_by_name(row[:location].upcase)
#         fills_repo(csv_files, row)
#       else
#         create(csv_files, row)
#       end
#     end
#   end
#
#   def create(csv_files, row)
#     year_range = convert_date_range(row[:timeframe])
#     data = row[:data].to_i
#     name = row[:location].upcase
#     @economic_profiles[name] = EconomicProfile.new( {:name => name,
# csv_files[0] => {year_range => data}} )
#   end
#
#   def convert_date_range(year_range)
#     year_range.split("-").map { |year| year.to_i }
#   end
#
#   def fills_repo(csv_files, row)
#     attribute = csv_files[0]
#     if attribute == :median_household_income
#       fill_median_income(row, attribute)
#     elsif attribute == :free_or_reduced_price_lunch
#       add_lunch(row, attribute)
#     else
#       epr = find_by_name(row[:location].upcase)
#       epr.send(attribute)[row[:timeframe].to_i] = row[:data].to_s[0..4].to_f
#     end
#   end
#
#   def fill_median_income(row, attribute)
#     epr = find_by_name(row[:location].upcase)
#     attribute = :median_household_income
#     data = row[:data].to_s[0..4].to_f
#     year = row[:timeframe].to_i
#     epr.send(attribute)[year] = data
#   end
#
#   def add_income(row, attribute)
#     attribute = :median_household_income
#     epr = find_by_name(row[:location].upcase)
#     year_range = convert_date_range(row[:timeframe])
#     data = row[:data].to_i
#     epr.send(attribute)[year_range] = data
#   end
#
#   def add_lunch(row, attribute)
#     epr = find_by_name(row[:location].upcase)
#     level = row[:poverty_level]
#     year = row[:timeframe].to_i
#     data = row[:data].to_s[0..4].to_f
#     if row[:poverty_level] == level
#       percent_or_number(row, attribute, year)
#     else
#       nil
#     end
#   end
#
#   def percent_or_number(row, attribute, year)
#     if row[:dataformat] == "Percent"
#       fill_with_percent(row, year, attribute)
#     elsif row[:dataformat] == "Number"
#       fill_with_number(row, year, attribute)
#     end
#   end
#
#   def fill_with_percent(row, year, attribute)
#     ep = find_by_name(row[:location].upcase)
#     if ep.send(attribute)[year].nil?
#       ep.send(attribute)[year] = {:percent => row[:data].to_s[0..4].to_f}
#     else
#       ep.send(attribute)[year].store(:percent, row[:data].to_s[0..4].to_f)
#     end
#   end
#
#   def fill_with_number(row, year, attribute)
#     ep = find_by_name(row[:location].upcase)
#     if ep.send(attribute)[year].nil?
#       ep.send(attribute)[year] = {:total => row[:data].to_s[0..4].to_f}
#     else
#       ep.send(attribute)[year].store(:total, row[:data].to_s[0..4].to_f)
#     end
#   end
#
# end
