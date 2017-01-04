require 'csv'

module DataParser
  def parse(filename)
    filename.map do |criteria, file|
      [criteria, (CSV.open file, headers: true, header_converters: :symbol)]
    end
  end
end
