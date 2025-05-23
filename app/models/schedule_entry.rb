class ScheduleEntry < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :classroom
  belongs_to :activity

  # Really want to validate that no two activities in the same classroom
  # overlap, but this is probably adequate for now
  validates :start_time, uniqueness: {scope: [:schedule, :classroom]}

  def end_time
    start_time + activity.duration.minutes
  end
end
