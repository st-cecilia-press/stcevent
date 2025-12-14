require "rails_helper"

RSpec.describe Event do
  it "can get the current event" do
    create(:event)
    expect(Event.current).not_to be_nil
  end

  it "current event is the most recent" do
    create(:event, start_date: Date.today - 1000)
    newer = create(:event, start_date: Date.today - 5)

    expect(Event.current.id).to eq(newer.id)
  end

  it "a future event is current" do
    create(:event, start_date: Date.today)
    newer = create(:event, start_date: Date.tomorrow)

    expect(Event.current.id).to eq(newer.id)
  end
  
  describe "#display_date" do
    it "shows one date when the beginning & end are the same" do
      event = build(:event, 
                    start_date: Date.parse("2026-04-07"), 
                    end_date: Date.parse("2026-04-07"))

      expect(event.display_date).to eq("April 7th, 2026")
    end

    it "shows begin & end date when they differ" do
      event = build(:event,
                    start_date: Date.parse("2024-05-06"),
                    end_date: Date.parse("2024-05-07"))

      expect(event.display_date).to eq("May 6th - 7th, 2024")
    end

    it "shows both months when start and end date are different months" do
      event = build(:event,
                    start_date: Date.parse("2024-05-31"),
                    end_date: Date.parse("2024-06-01"))

      expect(event.display_date).to eq("May 31st - June 1st, 2024")
    end
  end
end
