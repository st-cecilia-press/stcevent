require "rails_helper"

RSpec.describe "/events/:event_id/activities", type: :request do
  it "/activities should list activities for current event"
  it "/activities/:activity_id should use current event"

  describe "GET /events/:event_id/activities/:activity_id" do
    it "can get an activity" do
      activity = create(:activity, event: create(:event))

      get event_activity_url(activity.event, activity)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>#{activity.title}</title>")
    end

    it "converts markdown to html as expected" do
      activity = create(:activity, description: "# Here is a Header")
      get event_activity_url(activity.event, activity)

      expect(response.body).to include(%r{<h1[^>]*>Here is a Header</h1>})
    end

    it "doesn't fetch an activity for a different event it" do
      other_event = create(:event)
      activity = create(:activity, event: create(:event))

      get event_activity_url(other_event, activity)

      expect(response).to have_http_status(:not_found)
    end
  end
end
