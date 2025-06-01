class ScheduleEntry < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :classroom
  belongs_to :activity

  delegate :title, :description, :activity_type, :activity_subtype, :duration, :facilitators, to: :activity

  # Really want to validate that no two activities in the same classroom
  # overlap, but this is probably adequate for now
  validates :start_time, uniqueness: {scope: [:schedule, :classroom]}

  def end_time
    start_time + duration.minutes
  end
end
