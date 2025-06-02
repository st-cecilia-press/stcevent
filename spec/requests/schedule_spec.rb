require "rails_helper"

RSpec.describe "schedule", type: :request do
  let(:event) { create(:event) }
  let(:schedule) { create(:schedule, event: event) }
  let(:activity1) { create(:activity, event: event, duration: 60) }
  let(:activity2) { create(:activity, event: event) }
  # let!: ensure they exist even if we don't refer to them
  let!(:entry1) { create(:schedule_entry, schedule: schedule, activity: activity1, start_time: event.start_date + 10.hours) }
  let!(:entry2) { create(:schedule_entry, schedule: schedule, activity: activity2, start_time: event.start_date + 11.hours) }

  before(:each) do
    event.update(schedule: schedule)
  end

  describe "GET /schedule" do
    it "shows all scheduled activities for the current schedule for the default event" do
      get event_schedule_url(event, schedule)

      expect(response.body).to include(activity1.title)
      expect(response.body).to include(activity2.title)
    end

    it "does not show unscheduled activities" do
      unscheduled_activity = create(:activity, event: event)

      get event_schedule_url(event, schedule)

      expect(response.body).not_to include(unscheduled_activity.title)
    end

    it "should show the time for scheduled activities" do
      get event_schedule_url(event, schedule)
      expect(response.body).to include("10:00 AM - 11:00 AM")
    end

    it "orders activities by time" do
      # make sure entry1 (which was created first) has a later start time than entry2
      entry1.update(start_time: entry2.start_time + 1.hour)
      get event_schedule_url(event, schedule)

      # entry1's activity should show up second
      expect(response.body).to include(/#{entry2.title}.*#{entry1.title}/m)
    end
  end
end
