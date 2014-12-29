require_relative 'config'
require_relative 'database'
require_relative 'file_write'

config = Config.new
db = Database.new(config.base)

config.tables.each do |table|
  db.table(table)
  db.fields(config.fields(table))
  file = FileWrite.new([table, 'csv'].join('.'))
  while !db.is_end?
    file.write(db.next)
  end
end
