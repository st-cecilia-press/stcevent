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
end
