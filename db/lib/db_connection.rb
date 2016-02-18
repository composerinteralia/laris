require 'pg'

dir_name = File.expand_path(File.dirname(__FILE__))
APP_SQL_FILES = Dir["#{dir_name}/../migrations/*.sql"]

class DBConnection
  def self.open
    @conn = PG::Connection.new( :dbname => ENV[DATABASE_URL] )
  end

  def self.migrate
    APP_SQL_FILES.each do |file|
      instance.exec(File.read(file))
    end
  end

  def self.instance
    open if @conn.nil?
    @conn
  end

  def self.execute(query, params=[])
    query = number_placeholders(query)
    print_query(query, params)
    res = instance.exec(query, params)
  end

  def self.columns(table_name)
    instance.exec('SELECT * FROM information_schema.columns')
      .select { |x| x['table_name'] == table_name }
      .map { |x| x['column_name'].to_sym }
  end

  private

  def self.print_query(query, interpolation_args)
    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end

  def self.number_placeholders(query_string)
    count = 0
    query_string.chars.map do |char|
      if char == "?"
        count += 1
        "$#{count}"
      else
        char
      end
    end.join("")
  end
end
