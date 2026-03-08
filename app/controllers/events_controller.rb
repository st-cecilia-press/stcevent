class EventsController < ApplicationController
  def title_content
    content_for :title do
      @event.title
    end
  end

  def update
    if @event.update(event_params)
      redirect_to edit_event_path(event), notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.expect(
      event: [
        menus_attributes: [[
          :id,
          :order,
          :name,
          :_destroy,
          menu_items_attributes: [[
            :id,
            :order,
            :name,
            :url,
            :_destroy
          ]]
        ]]
      ]
    )
  end
end
