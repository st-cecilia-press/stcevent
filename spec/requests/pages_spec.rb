require "rails_helper"

RSpec.describe "GET /", type: :request do
  it "gets the 'home' page" do
    page = create(:page, slug: "home")

    get "/"

    expect(response.body).to include(page.title)
  end
end

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

    it "gets the page for the current event with the root route" do
      get "/"

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

  it "shows the menu for the event" do
    page = create(:page)
    menu_item = create(:menu_item, event: page.event)

    get "/#{page.slug}"

    expect(response.body).to include(menu_item.name)
  end

  it "shows up in the menu when it has a menu item" do
    page1 = create(:page)
    menu_item = create(:menu_item, event: page1.event)
    page1.menu_item = menu_item
    page1.save

    page2 = create(:page, event: page1.event)

    get "/#{page2.slug}"

    expect(response.body).to include(page1.title)
    expect(response.body).to include(page1.slug)
  end
end

RSpec.describe "GET /pages/:page_id/edit", type: :request do
  let(:user) { create(:user) }

  it "can get an edit page" do
    page = create(:page)

    get edit_page_path(page.id, as: user)

    expect(response).to have_http_status(:success)
  end

  it "gets the right page with a text box" do
    page = create(:page)

    get edit_page_path(page.id, as: user)

    doc = Nokogiri::HTML(response.body)

    expect(doc.css('input[type="text"][name="page[title]"]').attr("value").value).to eq(page.title)
    expect(doc.css("textarea").first.text.strip).to eq(page.body.strip)
  end

  it "has a submit button" do
    page = create(:page)

    get edit_page_path(page.id, as: user)

    expect(response.body).to include("submit")
  end

  it "gets a 404 when not signed in" do
    page = create(:page)

    get edit_page_path(page.id)

    expect(response).to have_http_status(:not_found)
  end
end

RSpec.describe "PATCH /pages/:page_id", type: :request do
  let(:user) { create(:user) }

  it "can edit the page and redirects to show the page" do
    page = create(:page)

    patch page_path(page.id, as: user), params: {page: {body: "# new body"}}

    expect(response).to have_http_status(:redirect)
    expect(response.redirect_url).to match(%r{.*/pages/#{page.id}$})

    page.reload
    expect(page.body).to eq("# new body")
  end
end
