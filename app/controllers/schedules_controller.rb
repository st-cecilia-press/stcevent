class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show]

  def title_content
    content_for :title do
      event.title + " Activity Schedule"
    end
  end

  def show
    @json_activities = ec_events_json

    # TODO -- only include non-empty classrooms
    @json_classrooms = ec_resources_json
  end

  def set_schedule
    @schedule = event.schedule
  end

  private

  def ec_events_json
    @schedule.entries.map do |entry|
      {
        start: entry.start_time.strftime("%Y-%m-%d %H:%m"),
        end: entry.end_time.strftime("%Y-%m-%d %H:%m"),
        resourceId: entry.classroom_id,
        title: { html: %{<a href="#entry_#{entry.id}">#{entry.title}</a>}
      }}
    end.to_json.html_safe
  end

  def ec_resources_json
    @event.classrooms.map do |classroom|
      { 
        id: classroom.id,
        title: classroom.name
      }
    end.to_json.html_safe
  end

end
