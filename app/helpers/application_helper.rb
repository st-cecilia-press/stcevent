module ApplicationHelper
  def title_from(thing)
    content_for :title do
      thing.title
    end
  end
end
