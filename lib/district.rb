
class District
  attr_reader :name, :district_repo
  def initialize(district_data, district_repo = nil)
    @name = district_data[:name].upcase
    @district_repo = district_repo
  end

  def enrollment
    district_repo.connect_with_enrollment(name)
  end
end
