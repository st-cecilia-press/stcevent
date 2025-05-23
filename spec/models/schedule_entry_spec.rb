require "rails_helper"

RSpec.describe ScheduleEntry do
  it "can compute the end times" do
    activity = create(:activity, duration: 60)

    start_time = DateTime.parse("2025-05-22T13:00-04:00")
    schedule_entry = build(:schedule_entry, activity: activity, start_time: start_time)

    expect(schedule_entry.end_time).to eq(DateTime.parse("2025-05-22T14:00-04:00"))
  end

  it "is not valid if there is another schedule entry with the same schedule, classroom, and start time" do
    entry1 = create(:schedule_entry)
    entry2 = build(:schedule_entry, schedule: entry1.schedule, classroom: entry1.classroom, start_time: entry1.start_time)

    expect(entry2).not_to be_valid
  end
end
