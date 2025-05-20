require "rails_helper"

RSpec.describe "people", type: :request do
  let(:user) { create(:user) }

  describe "GET /people/:person_id" do
    it "can get an person" do
      person = create(:person)

      get person_url(person)

      expect(response).to have_http_status(:success)
      expect(response.body).to include_escaped(person.name)
    end

    it "converts markdown to html as expected" do
      person = create(:person, bio: "# My life")
      get person_url(person)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(%r{<h1[^>]*>My life</h1>})
    end

    it "shows activities associated with the person" do
      activity1 = create(:activity)
      activity2 = create(:activity)
      person = create(:person, activities: [activity1, activity2])

      get person_url(person)

      expect(response.body).to include_escaped(activity1.title)
      expect(response.body).to include_escaped(activity2.title)
    end
  end
  describe "GET /people" do
    it "can show all people when logged in" do
      person1 = create(:person)
      person2 = create(:person)

      get people_url(as: user)

      expect(response).to have_http_status(:success)
      expect(response.body).to include_escaped(person1.name)
      expect(response.body).to include_escaped(person2.name)
    end
    it "does not show a link for adding a new Person when not logged in" do
      get people_url
      expect(response.body).not_to include(new_person_path)
    end
    it "has a link for adding a new Person when logged in" do
      get people_url(as: user.id)
      expect(response.body).to include(new_person_path)
    end
  end

  describe "GET /event/:event_id/teachers" do
    it "only shows people who are facilitating an activity for the given event" do
      facilitator = create(:person)
      activity = create(:activity, facilitators: [facilitator])
      non_facilitator = create(:person)

      get "/events/#{activity.event_id}/teachers"

      expect(response.body).to include(facilitator.name)
      expect(response.body).not_to include(non_facilitator.name)
    end

    it "does not show edit and delete buttons if you are not signed in" do
      person = create(:person)
      activity = create(:activity, facilitators: [person])

      get "/events/#{activity.event_id}/teachers"
      expect(response.body).not_to include(edit_person_path(person))
    end

    it "shows edit and delete buttons if signed in" do
      person = create(:person)
      activity = create(:activity, facilitators: [person])

      get "/events/#{activity.event_id}/teachers", params: {as: user.id}
      expect(response.body).to include(edit_person_path(person))
    end
  end

  describe "POST /people" do
    it "can create a new Person" do
      expect {
        post(people_url(as: user), params: {person: attributes_for(:person)})
      }.to change(Person, :count).by(1)
    end
  end

  describe "GET /people/new" do
    it "can get a new person form" do
      get new_person_url(as: user)

      expect(response).to have_http_status(:success)
    end

    it "form includes guidance on name" do
      get new_person_url(as: user)
      expect(response.body).to include(/usually be the sca name/i)
    end
  end
  describe "GET /people/:id/edit" do
    it "can get the edit person form" do
      person = create(:person)

      get edit_person_url(person, as: user)

      expect(response).to have_http_status(:success)
    end

    it "gets the right person with a text box" do
      person = create(:person)

      get edit_person_url(person, as: user)

      doc = Nokogiri::HTML(response.body)

      expect(doc.css('input[type="text"][name="person[name]"]').attr("value").value).to eq(person.name)
      expect(doc.css("textarea").first.text.strip).to eq(person.bio.strip)
    end

    it "has a submit button" do
      person = create(:person)

      get edit_person_url(person, as: user)

      expect(response.body).to include("submit")
    end

    it "gets a 404 when not signed in" do
      person = create(:person)

      get edit_person_url(person)

      expect(response).to have_http_status(:not_found)
    end
  end
  describe "PATCH /people/:person_id" do
    it "can edit the person and redirects to show the person" do
      person = create(:person)

      patch person_url(person, as: user), params: {person: {bio: "this is my life"}}

      expect(response).to have_http_status(:redirect)
      expect(response.redirect_url).to match(%r{.*/people/#{person.id}$})

      person.reload
      expect(person.bio).to eq("this is my life")
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested person" do
      person = create(:person)
      expect {
        delete person_url(person, as: user)
      }.to change(Person, :count).by(-1)
    end

    it "redirects to the people list" do
      person = create(:person)
      delete person_url(person, as: user)
      expect(response).to redirect_to(people_url)
    end

    it "destroys associated facilitations"
    it "does not destroy associated activities"
  end
end
