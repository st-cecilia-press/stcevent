class Person < ActiveRecord::Base
  validates :name, presence: true

  def title
    name
  end
end
