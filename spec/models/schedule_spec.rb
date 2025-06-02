require "rails_helper"

RSpec.describe Schedule do
  describe "#ec_events_json" do
    it "has correct times for event entries" do
      entry = create(:schedule_entry)
      entry.update(start_time: entry.schedule.event.start_date + 10.hours)

      output_json = JSON.parse(entry.schedule.entries_json)

      expect(output_json[0]["start"]).to match(/ 10:00$/)
    end
  end
end
