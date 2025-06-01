class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show]

  def title_content
    content_for :title do
      event.title + " Activity Schedule"
    end
  end

  def set_schedule
    @schedule = event.schedule
  end

end
