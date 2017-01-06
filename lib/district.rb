class District
  attr_reader :name, :parent
  def initialize(district_data, parent = nil)
    @name = district_data[:name].upcase
    @parent = parent
    # binding.pry
  end

  # def enrollment
  #   enrollment = EnrollmentRepository.new
  #   binding.pry
  #   enrollment.load_data(name)
  #   binding.pry
  # #   parent.connect_with_enrollment(name)
  # end
end
