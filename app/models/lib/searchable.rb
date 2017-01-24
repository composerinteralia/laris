module Searchable
  def all
    Relation.new(self)
  end

  def find(id)
    all.where(id: id).limit(1).first
  end

  def find_by(conditions)
    all.where(conditions).limit(1).first
  end

  def find_by_sql(sql, values = [])
    results = DBConnection.execute(sql, values)
    parse_all(results)
  end

  def first
    all.order(:id).limit(1).first
  end

  def last
    all.order(:id, :DESC).limit(1).first
  end

  def method_missing(method_name, *args)
    if method_name.to_s.start_with?("find_by_")
      columns = method_name[8..-1].split('_and_')

      conditions = {}
      columns.size.times { |i| conditions[columns[i]] = args[i] }

      all.where(conditions).limit(1).first
    else
      all.send(method_name, *args)
    end
  end

  def parse_all(results)
    results.map { |params| new(params) }
  end
end
