require 'csv'
require_relative '../lib/exception_handling'

class EconomicProfile
  attr_reader :median_household_income,
              :children_in_poverty,
              :free_or_reduced_price_lunch,
              :title_i,
              :name

  def initialize(econ_data)
    @median_household_income = econ_data[:median_household_income] || {}
    @children_in_poverty = econ_data[:children_in_poverty] || {}
    @free_or_reduced_price_lunch =econ_data[:free_or_reduced_price_lunch] || {}
    @title_i = econ_data[:title_i] || {}
    @name = econ_data[:name] || ""
  end

  def median_household_income_in_year(year)
    total_income = []
    @median_household_income.each do |range, income|
      if (range[0]..range[-1]).include?(year)
          total_income << median_household_income[range]
      end
    end
    (total_income.reduce(:+) / total_income.count).to_i
  end

  def median_household_income_average
    (@median_household_income.values.reduce(:+) /
    @median_household_income.count).to_i
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError if @children_in_poverty[year].nil?
    @children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError if @free_or_reduced_price_lunch[year].nil?
    @free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError if @free_or_reduced_price_lunch[year].nil?
    @free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    raise UnknownDataError if @title_i[year].nil?
    @title_i[year]
  end

end
