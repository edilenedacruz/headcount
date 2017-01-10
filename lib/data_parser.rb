require 'csv'

module DataParser
  def self.parse(filename)
    filename.map do |key, file|
      [key, (CSV.open file, headers: true, header_converters: :symbol)]
    end
  end
end
