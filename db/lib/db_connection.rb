require 'sqlite3'

dir_name = File.expand_path(File.dirname(__FILE__))
APP_SQL_FILES = Dir["#{dir_name}/../migrations/*.sql"]
APP_DB_FILE = File.join(dir_name, '../app.db')

class DBConnection
  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true

    @db
  end

  def self.reset
    commands = ["rm '#{APP_DB_FILE}'"]

    APP_SQL_FILES.each do |file|
      commands << "cat '#{file}' | sqlite3 '#{APP_DB_FILE}'"
    end

    commands.each { |command| `#{command}` }
    DBConnection.open(APP_DB_FILE)
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  private

  def self.print_query(query, *interpolation_args)
    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
