class FileWrite
  def initialize(filename = 'default.csv')
    @filename = Dir.pwd << '/output/' << filename
    File.open(@filename, 'w') {|file| file.truncate(0) }
  end

  def write(data_array)
    File.open(@filename, 'w') do |file|
      data_array.each do |data|
        file.write(string_from_data(data))
      end
    end
  end

  def string_from_data(data)
    data.map { |k, v| "\"#{v}\"" }.join(';') << "\n"
  end
end
