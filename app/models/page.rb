class Page < ActiveRecord::Base
  belongs_to :event
  belongs_to :menu_item, optional: true

  validates :event, presence: true
  validates :slug, presence: true
end
