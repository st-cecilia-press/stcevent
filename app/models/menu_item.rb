class MenuItem < ApplicationRecord
  belongs_to :event

  has_many :pages
end
