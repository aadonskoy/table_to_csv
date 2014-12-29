require 'mysql2'

class Database
  def initialize(options = {})
    @current_position = 1
    @chunk_size = 256
    @fileds = []
    @table = ''
    @client = Mysql2::Client.new(options)
  end

  def table(name)
    @current_position = 0
    @table = escape(name)
  end

  def fields(arr)
    @current_position = 0
    @fields = fields_to_string(arr)
  end

  def table_length
    check_table_name
    @client.query("SELECT COUNT(*) as length FROM `#{@table}`").first['length']
  end

  def first
    @current_position = 0
    read_table
  end

  def next
    read_table
  end

  def is_end?
    return true if @current_position >= table_length
    false
  end

  def chunk_size(size)
    @chunk_size = size
  end

  private

  def check_table_name
    raise 'Error! Please, set table name first.' if @table.empty?
  end

  def read_table
    @fields ||= '*'
    query = "SELECT #{@fields} FROM `#{@table}` LIMIT #{@chunk_size} OFFSET #{@current_position}"
    @current_position += @chunk_size
    @client.query(query)
  end

  def fields_to_string(fields = [])
    return '*' if fields.empty?
    fields.map { |field| escape(field) }.join(', ')
  end

  def escape(text)
    @client.escape(text)
  end
end
