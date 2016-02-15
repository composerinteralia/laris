require_relative 'lib/activerecord_base'

class User < ActiverecordBase
  finalize!

  has_many :posts
end
