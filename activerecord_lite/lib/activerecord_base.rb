require 'active_support/inflector'
require_relative '../db/db_connection'
require_relative 'associatable'
require_relative 'relation'
require_relative 'searchable'

class ActiverecordBase
  extend Associatable
  extend Searchable

  def self.columns
    return @columns if @columns

    columns = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT 0
    SQL

    @columns = columns.first.map(&:to_sym)
  end

  def self.destroy_all
    all.each { |row| row.destroy }
  end

  def self.destroy(row)
    row = find(row) if row.is_a?(Integer)
    row.destroy
  end

  def self.finalize!
    columns.each do |attr_name|
      define_method(attr_name) do
        attributes[attr_name]
      end

      define_method("#{attr_name}=") do |value|
        attributes[attr_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      if self.class.columns.include?(attr_name.to_sym)
        send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    columns.map { |attr_name| send(attr_name) }
  end

  def destroy
    DBConnection.execute2(<<-SQL, id)
      DELETE FROM
        #{table_name}
      WHERE
        #{table_name}.id = ?
    SQL

    self
  end

  def insert
    col_names = columns.join(", ")
    question_marks = (["?"] * columns.size).join(", ")

    result = DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id

    true
  end

  def save
    id ? update : insert
  end

  def update
    set_sql = columns.map { |attr_name| "#{attr_name} = ?" }.join(", ")

    result = DBConnection.execute(<<-SQL, *attribute_values, id)
      UPDATE
        #{table_name}
      SET
        #{set_sql}
      WHERE
        #{table_name}.id = ?
    SQL

    true
  end

  private
  def columns
    self.class.columns
  end

  def table_name
    self.class.table_name
  end
end
