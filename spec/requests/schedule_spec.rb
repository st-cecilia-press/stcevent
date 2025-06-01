require "rails_helper"

RSpec.describe "schedule", type: :request do

  let(:event) { create(:event) }
  let(:schedule) { create(:schedule, event: event) }
  let(:activity1) {  create(:activity, event: event, duration: 60) }
  let(:activity2) {  create(:activity, event: event) }

  before(:each) do 
    event.update(schedule: schedule)
    create(:schedule_entry, schedule: schedule, activity: activity1, start_time: event.start_date + 10.hours )
    create(:schedule_entry, schedule: schedule, activity: activity2, start_time: event.start_date + 11.hours )
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

    it "orders activities by time"
  end
end
