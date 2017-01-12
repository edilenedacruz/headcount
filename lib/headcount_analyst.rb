require_relative '../lib/enrollment_repository'
require_relative '../lib/district'
require_relative '../lib/enrollment'

class HeadcountAnalyst
  attr_reader :dr

  def initialize(dr)
    @dr = dr
  end

  def kindergarten_participation_rate_variation(dist_1, dist_2)
    dist_1 = kind_average_calculation(dist_1)
    dist_2 = kind_average_calculation(dist_2[:against])
    (dist_1 / dist_2).to_s[0..4].to_f
  end

  def kind_average_calculation(district)
    find_district = @dr.enrollment_repo.find_by_name(district)
    get_data = find_district.kindergarten_participation_by_year.values
    get_data.inject(:+) / get_data.size
  end

  def kindergarten_participation_rate_variation_trend(dt1, dt2)
    d1= @dr.enrollment_repo.find_by_name(dt1).kindergarten_participation_by_year
    data_2=@dr.enrollment_repo.find_by_name(dt2[:against])
    d2 = data_2.kindergarten_participation_by_year
    calc = {}
    d1.map {|k, v| calc[k] = (d1[k]/d2[k]).to_s[0..4].to_f}
    calc
  end

  def kindergarten_participation_against_high_school_graduation(dist)
    kv = kindergarten_participation_rate_variation(dist, :against => "COLORADO")
    grade_var = graduation_variation_calculation_against_state(dist)
    (kv / grade_var).to_s[0..4].to_f
  end

  def graduation_variation_calculation_against_state(dist)
    rate = @dr.enrollment_repo.find_by_name(dist).graduation_rate_by_year.values
    dist_average = rate.inject(:+) / rate.size
    state_rate = @dr.enrollment_repo.find_by_name("COLORADO")
    get_data_state = state_rate.graduation_rate_by_year.values
    state_average = get_data_state.inject(:+) /get_data_state.size
    (dist_average / state_average).to_s[0..4].to_f
  end

  def kindergarten_participation_correlates_with_high_school_graduation(dist)
    if dist[:for] == "STATEWIDE"
      statewide_correlation
    elsif dist.has_key?(:across)
      districts = dist[:across]
      multi_correlation = districts.map do |name|
        kindergarten_participation_against_high_school_graduation(name).between?(0.6, 1.5)
        end
      multi_correlation.count(true).to_f / multi_correlation.size > 0.70
    else
      kindergarten_participation_against_high_school_graduation(dist[:for]).between?(0.6, 1.5)
    end
  end

  def statewide_correlation
    wo_co = @dr.districts.select { |name, district| name != "COLORADO" }
    wo_co.keys.map do |name|
    kindergarten_participation_against_high_school_graduation(name).between?(0.6, 1.5)
    end
    wo_co.count(true).to_f / wo_co.size > 0.70
  end
end
