require_relative '../lib/enrollment_repository'
require_relative '../lib/district'


class HeadcountAnalyst
  attr_reader :district_repo
  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    district_1 = kind_average_calculation(district_1)
    district_2 = kind_average_calculation(district_2[:against])
    (district_1 / district_2).to_s[0..4].to_f
  end

  def kind_average_calculation(district)
    get_data = @district_repo.enrollment_repo.find_by_name(district).kindergarten_participation_by_year.values
    get_data.inject(:+) / get_data.size
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    get_data = @district_repo.enrollment_repo.find_by_name(district_1).kindergarten_participation_by_year
    get_data_2 = @district_repo.enrollment_repo.find_by_name(district_2[:against]).kindergarten_participation_by_year
    calc = {}
    get_data.map do |key, value|
      calc[key] = (get_data[key] / get_data_2[key]).to_s[0..4].to_f
    end
    calc
  end

  def kindergarten_participation_against_high_school_graduation(district)
    kindergarten_variation = kindergarten_participation_rate_variation(district, :against => "COLORADO")
    graduation_variation = graduation_variation_calculation_against_state(district)
    (kindergarten_variation / graduation_variation).to_s[0..4].to_f
  end

  def graduation_variation_calculation_against_state(district)
    get_data = @district_repo.enrollment_repo.find_by_name(district).graduation_rate_by_year.values
    dist_average = get_data.inject(:+) / get_data.size
    get_data_state = @district_repo.enrollment_repo.find_by_name("COLORADO").graduation_rate_by_year.values
    state_average = get_data_state.inject(:+) /get_data_state.size
    (dist_average / state_average).to_s[0..4].to_f
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    district_name = district[:for]
      if kindergarten_participation_against_high_school_graduation(district_name).between?(0.6, 1.5)
        true
      elsif district_name == "STATEWIDE"
        #then calculate for all and then see if more then 70? of districts across state show a correlation
      elsif district[:across]
        #calculate correlation across subset of districts
      end
  end
end
