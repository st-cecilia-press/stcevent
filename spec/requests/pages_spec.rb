require "rails_helper"

RSpec.describe "GET /:slug", type: :request do
  it "gets the right page" do
    page = create(:page, slug: "testpage")

    get "/testpage"

    expect(response).to have_http_status(:success)
    expect(response.body).to include("<title>#{page.title}</title>")
  end

  context "with two pages with the same slug for different events" do
    let(:old_event) { create(:event, start_date: Date.today - 1000) }
    let(:new_event) { create(:event, start_date: Date.today) }

    before(:each) do
      create(:page, event: old_event, title: "Very Outdated", slug: "home")
      create(:page, event: new_event, title: "Current Info", slug: "home")
    end

    it "gets the page for the current event" do
      get "/home"

      expect(response.body).to include("Current Info")
    end

    it "can get a page for a different event" do
      get "/events/#{old_event.id}/home"

      expect(response.body).to include("Very Outdated")
    end
  end

  it "converts markdown to html as expected" do
    create(:page, body: "# Here is a Header", slug: "headerpage")
    get "/headerpage"

    expect(response.body).to include(%r{<h1[^>]*>Here is a Header</h1>})
  end

  it "gets a 404 if the page doesn't exist" do
    get "/nonexistent"

    expect(response).to have_http_status(:not_found)
  end
end

RSpec.describe "GET /pages/:page_id/edit", type: :request do
  it "gets the right page with a text box" do
    page = create(:page)

    get "/pages/#{page.id}/edit"

    expect(response).to have_http_status(:success)

    doc = Nokogiri::HTML(response.body)

    expect(doc.css('input[type="text"][name="page[title]"]').attr('value').value).to eq(page.title)
    expect(doc.css("textarea").first.text.strip).to eq(page.body.strip)
  end
end
