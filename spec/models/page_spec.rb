require "rails_helper"

RSpec.describe Page do
  it "has a slug" do
    create(:page)

    expect(Page.first.slug).not_to be_nil
  end
  it "cannot have a slug that conflicts with another route"
  # example "/activities" or "/locations" or "/events"
end
