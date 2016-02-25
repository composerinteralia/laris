require 'pg'
require 'uri'

dir_name = File.expand_path(File.dirname(__FILE__))
APP_SQL_FILES = Dir["#{dir_name}/../migrations/*.sql"]

class DBConnection
  def self.open
    uri = URI.parse(ENV['DATABASE_URL'])

    @conn = PG::Connection.new(
      user: uri.user,
      password: uri.password,
      host: uri.host,
      port: uri.port,
      dbname: uri.path[1..-1],
    )
  end

  def self.migrate
    ensure_migrations_table

    APP_SQL_FILES.each do |file|
      filename = file.match(/([\w|-]*)\.sql$/)[1]

      unless migrated_files.include?(filename)
        instance.exec(File.read(file))
        instance.exec(<<-SQL)
          INSERT INTO
            migrations (filename)
          VALUES
            ('#{filename}')
          SQL
      end
    end
  end

  def self.execute(query, params=[])
    query = number_placeholders(query)
    print_query(query, params)
    res = instance.exec(query, params)
  end

  def self.columns(table_name)
    cols = instance.exec(<<-SQL)
      SELECT
        attname
      FROM
        pg_attribute
      WHERE
        attrelid = '#{table_name}'::regclass AND
        attnum > 0 AND
        NOT attisdropped
    SQL

    cols.map { |col| col['attname'].to_sym }
  end

  private

  def self.ensure_migrations_table
    res = instance.exec(<<-SQL)
      SELECT to_regclass('migrations') AS exists
    SQL

    unless res[0]['exists']
      instance.exec(<<-SQL)
        CREATE TABLE migrations (
          id SERIAL PRIMARY KEY,
          filename VARCHAR(255) NOT NULL
        )
      SQL
    end
  end

  def self.instance
    open if @conn.nil?
    @conn
  end

  def self.migrated_files
    Set.new instance.exec(<<-SQL).values.flatten
      SELECT
        filename
      FROM
        migrations
    SQL
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

  def self.print_query(query, interpolation_args)
    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
