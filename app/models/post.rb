require_relative 'lib/activerecord_base'

class Post < ActiverecordBase
  finalize!

  belongs_to :author, class_name: "User", foreign_key: :user_id
end
