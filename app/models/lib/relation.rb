class Relation
    SQL_COMMANDS = {
      select: 'SELECT',
      from: 'FROM',
      joins: 'JOIN',
      where: 'WHERE',
      order: 'ORDER BY',
      limit: 'LIMIT'
    }

    attr_reader :klass, :sql_clauses
    attr_accessor :cache, :values

    def initialize(klass, values = [], sql_clauses = {})
      @klass = klass
      @values = values
      @sql_clauses = sql_defaults.merge(sql_clauses)
      @cache = nil
    end

    def method_missing(method, *args)
      query if cache.nil?
      cache.send(method, *args)
    end

    def reload!
      query
    end

    def order(column, direction = 'ASC')
      sql_clauses[:order] = "#{table_name}.#{column} #{direction}"
      self
    end

    # allows only a single join
    def joins(table, on = nil)
      condition = "#{table} ON #{on}"

      sql_clauses[:joins] =
        [sql_clauses[:joins], condition].compact.join(' JOIN ')

      self
    end

    def limit(n)
      sql_clauses[:limit] = n
      self
    end

    def where(conditions)
      new_fragments = conditions.map do |attr_name, value|
        values << value
        "#{table_name}.#{attr_name} = ?"
      end

      where_fragments = new_fragments.unshift(sql_clauses[:where])
      sql_clauses[:where] = where_fragments.compact.join(" AND ")

      self
    end

    private
    def query
      results = DBConnection.execute(statement, values)
      self.cache = klass.parse_all(results)
    end

    def sql_defaults
      {
        select: "#{table_name}.*",
        from: "#{table_name}"
      }
    end

    def statement
      clauses = SQL_COMMANDS.map do |keyword, command|
        "#{command} #{sql_clauses[keyword]}" if sql_clauses[keyword]
      end
      clauses.compact.join(" ")
    end

    def table_name
      klass.table_name
    end
end
