class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy]

  def index
    @pages = Page.where(event: params.expect(:event_id))
  end

  def new
    @page = Page.new
  end

  # POST /pages
  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to [event, @page], notice: "Page was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pages/1
  def update
    Page.find(params[:id])
    if @page.update(page_params)
      redirect_to [event, @page], notice: "Page was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def title_content
    content_for :title do
      @page.title
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy!
    redirect_to event_pages_path(event), notice: "Page was successfully destroyed.", status: :see_other
  end

  private

  def page_params
    params.expect(page: [:slug, :body, :title]).merge(event: event)
  end

  def set_page
    @page = if params[:slug]
      Page.find_by!(slug: params[:slug], event: event)
    else
      Page.find(params.expect(:id))
    end
  end
end
