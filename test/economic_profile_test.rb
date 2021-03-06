require_relative 'test_helper'
require_relative '../lib/economic_profile'

class EconomicProfileTest < Minitest::Test
  attr_reader :epr

  def setup
    @epr = EconomicProfileRepository.new
    epr.load_data({
      :economic_profile => {
        :median_household_income => "test/fixtures/Median household income.csv",
        :children_in_poverty => "test/fixtures/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "test/fixtures/Students qualifying for free or reduced price lunch.csv",
        :title_i => "test/fixtures/Title I students.csv"
      }
      })
  end
  def test_it_can_access_median_household_income_in_year
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal 85060, ep.median_household_income_in_year(2005)
  end

  def test_it_can_access_median_household_income_average
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal 87635, ep.median_household_income_average
  end

  def test_it_can_access_children_in_poverty_in_specific_year
    ep = epr.find_by_name("ACADEMY 20")
    assert_in_delta 0.064, ep.children_in_poverty_in_year(2012), 0.005
  end

  def test_it_can_access_free_or_reduced_price_lunch_percentage_in_given_year
    ep = epr.find_by_name("ACADEMY 20")
    assert_in_delta 0.127, ep.free_or_reduced_price_lunch_percentage_in_year(2014), 0.005
  end

  def test_it_can_access_number_of_children_that_has_access_to_free_or_reduced_lunch
    ep = epr.find_by_name("ACADEMY 20")
    assert_equal 3132, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_it_can_provide_percentage_of_kids_receiving_assistance
    ep = epr.find_by_name("ACADEMY 20")
    assert_in_delta 0.027, ep.title_i_in_year(2014), 0.005
  end
end
