class ApplicationController < ActionController::Base
  include Clearance::Controller

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :set_event

  allow_browser versions: :modern

  def set_event
    @event = if params[:event_id]
      Event.find(params[:event_id])
    else
      Event.current
    end
  end

  attr_reader :event
end
