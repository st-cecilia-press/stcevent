class Activity < ActiveRecord::Base
  belongs_to :difficulty, optional: true
  belongs_to :event
  belongs_to :classroom, optional: true
  belongs_to :activity_type, optional: true
  belongs_to :activity_subtype, optional: true
  #  has_many :teachers, dependent: :destroy
  #  has_many :users, through: :teachers

  validates :title, presence: true
  validates :duration, presence: true
end
