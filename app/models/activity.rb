class Activity < ActiveRecord::Base
  # DEPRECATED FIELDS -- should use ScheduleEntry: classroom, start_time
  #
  belongs_to :difficulty, optional: true
  belongs_to :event
  belongs_to :activity_type, optional: true
  belongs_to :activity_subtype, optional: true
  has_many :facilitations, dependent: :destroy
  has_many :facilitators, source: :person, through: :facilitations

  validates :title, presence: true
  validates :duration, presence: true
end
