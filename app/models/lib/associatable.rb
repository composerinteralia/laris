class AssocOptions
  attr_accessor :class_name, :foreign_key, :primary_key

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(assoc_name, options = {})
    defaults = {
      class_name: assoc_name.to_s.camelcase,
      foreign_key: "#{assoc_name}_id".to_sym,
      primary_key: :id
    }

    defaults.each do |attr, default|
      send("#{attr}=", (options[attr] || default))
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(assoc_name, self_name, options = {})
    defaults = {
      class_name: assoc_name.to_s.singularize.camelcase,
      foreign_key: "#{self_name.underscore}_id".to_sym,
      primary_key: :id
    }

    defaults.each do |attr, default|
      send("#{attr}=", (options[attr] || default))
    end
  end
end

module Associatable
  def belongs_to(assoc_name, options = {})
    options = BelongsToOptions.new(assoc_name, options)
    assoc_options[assoc_name] = options

    define_method(assoc_name) do
      klass = options.model_class
      foreign_key_value = send(options.foreign_key)
      primary_key = options.primary_key

      klass.where(primary_key => foreign_key_value).first
    end
  end

  def has_many(assoc_name, options = {})
    options = HasManyOptions.new(assoc_name, self.name, options)

    define_method(assoc_name) do
      klass = options.model_class
      foreign_key = options.foreign_key
      primary_key_value = send(options.primary_key)

      klass.where(foreign_key => primary_key_value)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(assoc_name, through_name, source_name)
    define_method(assoc_name) do
      through_options = assoc_options[through_name]
      through_klass = through_options.model_class
      through_table = through_klass.table_name
      through_fk_value = send(through_options.foreign_key)
      through_pk = through_options.primary_key

      source_options = through_klass.assoc_options[source_name]
      source_klass = source_options.model_class
      source_table = source_klass.table_name
      source_fk = source_options.foreign_key
      source_pk = source_options.primary_key

      result = DBConnection.execute(<<-SQL, through_fk_value)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_fk} = #{source_table}.#{source_pk}
        WHERE
          #{through_table}.#{through_pk} = ?
      SQL

      source_klass.new(result.first)
    end
  end
end
