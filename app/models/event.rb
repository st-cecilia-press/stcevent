class Event < ActiveRecord::Base
  has_many :menus
  has_many :activities
  has_many :classrooms
  belongs_to :schedule, optional: true

  validates :title, :start_date, :end_date, presence: true

  # Current event is the most recent (even if the most recent is in the future)
  scope :current, -> { order(start_date: :desc).limit(1).first }

  def classrooms_json
    classrooms.map do |classroom|
      {
        id: classroom.id,
        title: classroom.name
      }
    end.to_json.html_safe
  end

  def display_date
    start_date.to_date.to_formatted_s(:long_ordinal)
  end
end
