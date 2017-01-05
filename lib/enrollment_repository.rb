class EnrollmentRepository
  attr_reader :enrollments
  def initialize
    @enrollments = {}
  end

  def load_data(files)
    filename = files[:enrollment][:kindergarten]
    contents = CSV.open filename, headers: true, header_converters: :symbol
    year = []
    data = []
    contents.map do |row|
      name = row[:location].upcase
      year << row[:timeframe].to_i #maybe needs to .round(3)
      data << row[:data].to_f
      year_data_hash = year.zip(data).to_h
      @enrollments[name.upcase] = Enrollment.new({:name => name, :kindergarten_participation => year_data_hash})
    end
  end

  def find_by_name(name)
    @enrollments[name.upcase]
    binding.pry
  end
end
