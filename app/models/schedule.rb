class Schedule < ActiveRecord::Base
  belongs_to :event

  has_many :entries, class_name: "ScheduleEntry"

  def ordered_entries
    entries.includes(:classroom).order(:start_time, "classroom.name")
  end
end
