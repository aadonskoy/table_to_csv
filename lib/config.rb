require 'erb'
require 'yaml'

class Config
  def initialize
    file_path = [Dir.pwd, '/config/config.yml'].join
    @data = YAML.load(ERB.new(File.read(file_path)).result)
  end

  def data
    @data
  end

  def base
    @data['mysql']
  end

  def tables
    @data['tables'].map { |k, v| k }
  end

  def fields(table)
    @data['tables'][table.to_s].map { |k, v| k }
  end
end
