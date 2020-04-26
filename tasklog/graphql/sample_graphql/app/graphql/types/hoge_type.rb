module Types
  class HogeType < BaseObject
    field :id, Int, null: false
    field :title, String, null: false
    field :content, String, null: false
  end
end