require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repo
  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1 = kind_average_calculation(district_1)
    district_2 = kind_average_calculation(district_2[:against])
    ((district_1 / district_2) * 1000).floor / 1000.0
    #(i.e. find the district's average participation across all years and divide it by the average of the state participation data across all years.)
  end

  def kind_average_calculation(district)
    get_data = @district_repo.enrollment_repo.find_by_name(district).kindergarten_participation_by_year.values
    average = get_data.inject(:+) / get_data.size
  end
  #
  # def kindergarten_participation_rate_variation_trend(district_1, district_2)
  # # => {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
  # end
end
