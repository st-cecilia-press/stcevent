class PagesController < ApplicationController
  def show
    if(params[:slug])
      @page = Page.find_by!(slug: params[:slug], event: event)
    else
      @page = Page.find(params[:id])
    end
  end

  def update
    page = Page.find(params[:id])
    page.update(page_params)

    redirect_to page_path(page)
  end

  alias :edit :show

  def title_content
    content_for :title do
      @page.title
    end
  end

  def page_params
    params.expect(page: [:slug, :body, :title])
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
