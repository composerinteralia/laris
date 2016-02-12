require_relative '../activerecord'

# NB database resets every time for testing
DBConnection.reset

class Human < ActiverecordBase
  self.table_name = "humans"
  finalize!

  has_many :cats, foreign_key: :owner_id
end

class Cat < ActiverecordBase
  finalize!

  belongs_to :owner, class_name: "Human", foreign_key: :owner_id
end
