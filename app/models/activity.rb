class Activity < ActiveRecord::Base
  belongs_to :difficulty
  belongs_to :event
  belongs_to :classroom, optional: true
  belongs_to :activity_type
  belongs_to :activity_subtype
  #  has_many :teachers, dependent: :destroy
  #  has_many :users, through: :teachers

  validates :title, presence: true
  validates :duration, presence: true
end
