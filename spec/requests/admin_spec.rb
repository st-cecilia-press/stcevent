require "rails_helper"

RSpec.describe "/", type: :request do
  let(:user) { create(:user) }
  before(:each) do
    create(:page, slug: "home")
  end
  it "shows admin menu item for a logged in user" do
    get root_url as: user
    expect(response.body).to include("Admin")
  end
  it "does not show a menu item for an anonymous user" do
    get root_url
    expect(response.body).not_to include("Admin")
  end
  it "has a Sign out link in the admin dropdown" do
    get root_url as: user
    expect(response.body).to include("Sign out")
  end
end

RSpec.describe "/sign_in", type: :request do
  it "shows a flash error when failing to sign in" do
    create(:page, slug: "home")
    post session_url, params: {session: {email: "nobdy@donotexist.invalid", password: "invalidpassword"}}
    expect(response.body).to include("Bad email or password.")
  end
end
