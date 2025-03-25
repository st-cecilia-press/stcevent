class Event < ActiveRecord::Base
  has_many :menu_items

  validates :title, :start_date, :end_date, presence: true

  # Current event is the most recent (even if the most recent is in the future)
  scope :current, -> { order(start_date: :desc).limit(1).first }
end
