require "rails_helper"

RSpec.describe "/", type: :request do
  let(:user) { create(:user) }
  before(:all) do
    create(:page, slug: "home")
  end
  it "shows admin menu item for a logged in user" do
    user = create(:user)
    get root_url as: user
    expect(response.body).to include("Admin")
  end
  it "does not show a menu item for an anonymous user" do
    get root_url
    expect(response.body).not_to include("Admin")
  end
end
