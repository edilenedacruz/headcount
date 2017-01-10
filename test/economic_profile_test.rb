# require_relative 'test_helper'
# require_relative '../lib/economic_profile'
#
# class EconomicProfileTest < Minitest::Test
#   attr_reader :economic_profile
#   def setup
#     data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
#         :children_in_poverty => {2012 => 0.1845},
#         :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
#         :title_i => {2015 => 0.543},
#         :name => "ACADEMY 20"
#        }
#     @economic_profile = EconomicProfile.new(data)
#   end
#
#   def test_it_can_access_median_household_income_in_year(year)
#     # assert_equal 50000, economic_profile.median_household_income_in_year(2005)
#   end
# end
