class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show]

  def title_content
    content_for :title do
      @activity.title
    end
  end

  private

  def set_activity
    @activity = Activity.find_by!(event: event, id: params.expect(:id))
  end
end
