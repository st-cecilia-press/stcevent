class PagesController < ApplicationController
  def show
    @page = Page.find_by(slug: params[:slug], event: event)
  end

  def title_content
    content_for :title do
      @page.title
    end
  end

  private

  def event
    if params[:event_id]
      Event.find(params[:event_id])
    else
      Event.current
    end
  end
end
