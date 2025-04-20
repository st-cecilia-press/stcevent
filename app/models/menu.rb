class Menu < ApplicationRecord
  belongs_to :event

  has_many :menu_items
end
