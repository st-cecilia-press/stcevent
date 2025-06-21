module ApplicationHelper
  # Hardcoded for now; could vary by event in the future
  EVENT_SERIES = "St. Cecilia"

  def title_from(thing)
    content_for :title, thing.title
  end

  def title
    content = content_for(:title)
    if content
      "#{content} - #{EVENT_SERIES}"
    else
      EVENT_SERIES
    end
  end

  def alert_class(type)
    case type
    when "alert"
      "alert-danger"
    when "notice"
      "alert-success"
    else
      type
    end
  end
end
