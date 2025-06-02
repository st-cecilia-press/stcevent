class Schedule < ActiveRecord::Base
  belongs_to :event

  has_many :entries, class_name: "ScheduleEntry"

  def ordered_entries
    entries.includes(:classroom).order(:start_time, "classroom.name")
  end

  def entries_json
    entries.map do |entry|
      {
        start: entry.start_time.strftime("%Y-%m-%d %H:%M"),
        end: entry.end_time.strftime("%Y-%m-%d %H:%M"),
        resourceId: entry.classroom_id,
        title: {html: %(<a href="#entry_#{entry.id}">#{entry.title}</a>)}
      }
    end.to_json.html_safe
  end
end
