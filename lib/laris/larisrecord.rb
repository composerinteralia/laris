require_relative 'larisrecord/associatable'
require_relative 'larisrecord/db_connection'
require_relative 'larisrecord/larisrecord_base'
require_relative 'larisrecord/relation'
require_relative 'larisrecord/searchable'

class LarisrecordBase
  extend Associatable
  extend Searchable
end

TracePoint.new(:end) do |tp|
  klass = tp.binding.receiver
  klass.laris_finalize! if klass.respond_to?(:laris_finalize!)
end.enable
