require_relative 'district_repository'
require_relative 'enrollment_repository'

class HeadcountAnalyst
  attr_reader :dr
  def initialize(dr)
    @dr = DistrictRepository.new
  end

  # def kindergarten_participation_rate_variation(district_1, district_2)
  # # => 0.447
  # end
  #
  # def kindergarten_participation_rate_variation_trend(district_1, district_2)
  # # => {2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992, 2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727, 2012 => 0.688, 2013 => 0.694, 2014 => 0.661 }
  # end
end
