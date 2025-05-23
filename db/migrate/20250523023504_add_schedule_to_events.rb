class AddScheduleToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :schedule, foreign_key: true
  end
end
