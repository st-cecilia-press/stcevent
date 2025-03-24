class PagesController < ApplicationController
  def show
    if(params[:slug])
      @page = Page.find_by!(slug: params[:slug], event: event)
    else
      @page = Page.find_by!(id: params[:id])
    end
  end

  alias :edit :show

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
