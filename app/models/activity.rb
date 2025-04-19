class Activity < ActiveRecord::Base
  belongs_to :difficulty, optional: true
  belongs_to :event
  belongs_to :classroom, optional: true
  belongs_to :activity_type, optional: true
  belongs_to :activity_subtype, optional: true
  has_many :facilitations, dependent: :destroy
  has_many :people, through: :facilitations

  validates :title, presence: true
  validates :duration, presence: true
end
