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

    return "NO NEW YEAR'S EVE EVENTS" unless start_date.year == end_date.year

    if(start_date.to_date == end_date.to_date)
      start_date.to_date.to_formatted_s(:long_ordinal)
    elsif start_date.month == end_date.month
      # e.g. September 6th - 7th, 2024
      [ 
        start_date.strftime("%B"),
        start_date.day.ordinalize, 
        "-",
        end_date.day.ordinalize + ",",
        start_date.year
      ].join(" ")
    else
      # e.g. May 31st - June 1st, 2023
      [ 
        start_date.strftime("%B"),
        start_date.day.ordinalize, 
        "-",
        end_date.strftime("%B"),
        end_date.day.ordinalize + ",",
        start_date.year
      ].join(" ")
    end


  end
end
