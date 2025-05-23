class CreateScheduleEntry < ActiveRecord::Migration[8.0]
  def change
    create_table :schedule_entries do |t|
      t.references :schedule, null: false
      t.references :activity, null: false
      t.references :classroom, null: false
      t.datetime :start_time

      t.timestamps
    end
  end
end
