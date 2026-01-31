class MenuItem < ApplicationRecord
  belongs_to :menu
  validates :order, presence: true
end
