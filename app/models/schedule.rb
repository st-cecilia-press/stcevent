class Schedule < ActiveRecord::Base
  belongs_to :event

  has_many :entries, class_name: "ScheduleEntry"
end
