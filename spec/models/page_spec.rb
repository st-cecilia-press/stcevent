require "rails_helper"

RSpec.describe Page do
  it "has a slug" do
    create(:page)

    expect(Page.first.slug).not_to be_nil
  end
end
