require "rails_helper"

RSpec.describe "/events/:event_id/activities", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  it "/activities/:activity_id should use current event"

  describe "GET /events/:event_id/activities/:activity_id" do
    it "can get an activity" do
      activity = create(:activity, event: create(:event))

      get event_activity_url(activity.event, activity)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("<title>#{activity.title}</title>")
    end

    it "has an edit link when logged in" do
      activity = create(:activity, event: create(:event))

      get event_activity_url(activity.event, activity, as: user)

      expect(response.body).to include(edit_event_activity_path(activity.event, activity))
    end
    it "converts markdown to html as expected" do
      activity = create(:activity, description: "# Here is a Header")
      get event_activity_url(activity.event, activity)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(%r{<h1[^>]*>Here is a Header</h1>})
    end

    it "doesn't fetch an activity for a different event it" do
      other_event = create(:event)
      activity = create(:activity, event: create(:event))

      get event_activity_url(other_event, activity)

      expect(response).to have_http_status(:not_found)
    end

    it "shows facilitators associated with the activity" do
      person1 = create(:person)
      person2 = create(:person)
      activity = create(:activity, facilitators: [person1, person2])

      get event_activity_url(activity.event, activity)

      expect(response.body).to include_escaped(person1.name)
      expect(response.body).to include_escaped(person2.name)
    end
  end

  describe "activities index" do
    def index_test(url)
      activity1 = create(:activity, event: event)
      activity2 = create(:activity, event: event)

      get url

      expect(response).to have_http_status(:success)
      expect(response.body).to include(activity1.title)
      expect(response.body).to include(activity2.title)
    end

    it "has a link for adding a new activity to the event" do
      activity = create(:activity)
      get event_activities_url(activity.event, as: user.id)
      expect(response.body).to include(new_event_activity_path(activity.event))
    end

    it "does not have a link to add an activity when not signed in" do
      activity = create(:activity)
      get event_activities_url(activity.event)
      expect(response.body).not_to include(new_event_activity_path(activity.event))
    end

    it "works for /event/:event_id/activities" do
      index_test(event_activities_url(event))
    end

    it "works for /activities" do
      index_test("/activities")
    end

    it "works for /classes" do
      index_test("/classes")
    end

    it "does not show edit and delete buttons if you are not signed in" do
      activity = create(:activity)

      get event_activities_url(activity.event)
      expect(response.body).not_to include(edit_event_activity_path(activity.event, activity))
    end

    it "shows edit and delete buttons if are not signed in" do
      activity = create(:activity)

      get event_activities_url(activity.event, as: user)
      expect(response.body).to include(edit_event_activity_path(activity.event, activity))
    end
  end

  describe "POST /events/:event_id/activities" do
    it "can create a new Activity" do
      expect {
        post(event_activities_url(event, as: user), params: {activity: attributes_for(:activity)})
      }.to change(Activity, :count).by(1)
    end
  end

  describe "GET /events/:event_id/activities/new" do
    it "can get a new activity form" do
      get new_event_activity_url(event, as: user)

      expect(response).to have_http_status(:success)
    end
  end
  describe "GET /events/:event_id/activities/:id/edit" do
    it "can get the edit activity form" do
      activity = create(:activity)

      get edit_event_activity_url(activity.event, activity, as: user)

      expect(response).to have_http_status(:success)
    end

    it "gets the right activity with a text box" do
      activity = create(:activity)

      get edit_event_activity_url(activity.event, activity, as: user)

      doc = Nokogiri::HTML(response.body)

      expect(doc.css('input[type="text"][name="activity[title]"]').attr("value").value).to eq(activity.title)
      expect(doc.css("textarea").first.text.strip).to eq(activity.description.strip)
    end

    it "has a submit button" do
      activity = create(:activity)

      get edit_event_activity_url(activity.event, activity, as: user)

      expect(response.body).to include("submit")
    end

    it "gets a 404 when not signed in" do
      activity = create(:activity)

      get edit_event_activity_url(activity.event, activity)

      expect(response).to have_http_status(:not_found)
    end

    it "can choose a person to add a facilitation"
    it "can add an additional person"
  end
  describe "PATCH /activities/:activity_id" do
    it "can edit the activity and redirects to show the activity" do
      activity = create(:activity)

      patch event_activity_url(activity.event, activity, as: user), params: {activity: {description: "new description"}}

      expect(response).to have_http_status(:redirect)
      expect(response.redirect_url).to match(%r{.*/activities/#{activity.id}$})

      activity.reload
      expect(activity.description).to eq("new description")
    end

    it "can add a facilitator" do
      activity = create(:activity)
      person = create(:person)

      patch event_activity_url(activity.event, activity, as: user), params: {activity: {facilitator_ids: [person.id]}}

      expect(response).to have_http_status(:redirect)
      activity.reload
      expect(activity.facilitators.first).to eq(person)
    end

    it "can add several facilitators" do
      activity = create(:activity)
      people = create_list(:person, 3)

      patch event_activity_url(activity.event, activity, as: user), params: {activity: {facilitator_ids: people.map(&:id)}}

      expect(response).to have_http_status(:redirect)
      activity.reload
      expect(activity.facilitators).to contain_exactly(*people)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested activity" do
      activity = create(:activity)
      expect {
        delete event_activity_url(activity.event, activity, as: user)
      }.to change(Activity, :count).by(-1)
    end

    it "redirects to the activities list" do
      activity = create(:activity)
      delete event_activity_url(activity.event, activity, as: user)
      expect(response).to redirect_to(event_activities_url(activity.event))
    end

    it "destroys associated facilitations"
    it "does not destroy associated activities"
  end
end
