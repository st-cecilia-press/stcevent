class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[show edit update destroy]

  def title_content
    content_for :title do
      @activity.title
    end
  end

  def index
    @activities = event.activities
    @heading = "Classes"
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to [event, @activity], notice: "Activity was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to [event, @activity], notice: "Activity was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @activity.destroy!
    redirect_to event_activities_path(event), notice: "Activity was successfully destroyed.", status: :see_other
  end

  private

  def activity_params
    params.expect(
      activity: [
        :title,
        :duration,
        :description,
        :classroom_id,
        :activity_type_id,
        :activity_subtype_id,
        :difficulty_id,
        facilitator_ids: []
      ]
    ).merge(event: event)
  end

  def set_activity
    @activity = Activity.find_by!(event: event, id: params.expect(:id))
  end
end
