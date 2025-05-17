module ApplicationHelper
  def title_from(thing)
    content_for :title do
      thing.title
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
