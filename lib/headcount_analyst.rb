require_relative 'district_repository'

class HeadcountAnalyst
  attr_reader :district_repo
  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1 = kind_average_calculation(district_1)
    district_2 = kind_average_calculation(district_2[:against])
    (((district_1 / district_2) * 1000) / 1000.0).round(3)
  end

  def kind_average_calculation(district)
    get_data = @district_repo.enrollment_repo.find_by_name(district).kindergarten_participation_by_year.values
    average = get_data.inject(:+) / get_data.size
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    get_data = @district_repo.enrollment_repo.find_by_name(district_1).kindergarten_participation_by_year
    get_data_2 = @district_repo.enrollment_repo.find_by_name(district_2[:against]).kindergarten_participation_by_year
    calc = {}
    get_data.map do |key, value|
      calc[key] = ((get_data[key] / get_data_2[key]).to_f * 1000 / 1000.0).round(3)
    end
    calc
    # binding.pry

  end
end
