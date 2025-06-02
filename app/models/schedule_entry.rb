class ScheduleEntry < ActiveRecord::Base
  TIME_DISPLAY_FORMAT = "%l:%M %p" # e.g. 9:00 AM

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

  def time_range_display
    start_time.strftime(TIME_DISPLAY_FORMAT) + " - " + end_time.strftime(TIME_DISPLAY_FORMAT)
  end
end
