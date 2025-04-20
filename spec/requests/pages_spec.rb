require "rails_helper"

RSpec.describe "/event/1/pages", type: :request do
  let(:user) { create(:user) }

  # missing a slug
  let(:invalid_attributes) do
    {
      body: "mashed potato",
      event: Event.first,
      title: "Mashed Potato"
    }
  end

  describe "GET /" do
    it "gets the 'home' page" do
      page = create(:page, slug: "home")

      get "/"

      expect(response.body).to include(page.title)
    end
  end

  describe "GET index" do
    it "shows all pages for that event" do
      page1 = create(:page)
      page2 = create(:page, event: page1.event)
      another_event_page = create(:page)

      get event_pages_url(page1.event, as: user.id)
      expect(response).to be_successful

      [page1, page2].each do |page|
        expect(response.body).to include(page.slug)
        expect(response.body).to include(page.title)
      end

      expect(response.body).not_to include(another_event_page.slug)
    end
  end

  describe "POST /events/:event_id/pages" do
    let(:event) { create(:event) }

    context "with valid parameters" do
      it "creates a new Page" do
        expect {
          post event_pages_url(event, as: user), params: {page: attributes_for(:page)}
        }.to change(Page, :count).by(1)
      end

      it "redirects to the created page" do
        post event_pages_url(event, as: user), params: {page: attributes_for(:page)}

        expect(response).to redirect_to(event_page_url(event, Page.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new page" do
        expect {
          post event_pages_url(event, as: user), params: {page: invalid_attributes}
        }.to change(Page, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post event_pages_url(event, as: user), params: {page: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /:slug" do
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

      it "has an edit link when logged in" do
        page = create(:page)

        get "/#{page.slug}", params: {as: user.id}

        expect(response.body).to include(edit_event_page_path(page.event, page))
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
      menu = create(:menu, event: page.event)

      get "/#{page.slug}"

      expect(response.body).to include(menu.name)
    end

    # TODO move to menu_item request spec
    it "shows up in the menu" do
      page = create(:page)
      menu = create(:menu, event: page.event)
      menu_item = create(:menu_item, menu: menu)

      get "/#{page.slug}"

      expect(response.body).to include(menu_item.name)
      expect(response.body).to include(menu_item.url)
    end
  end

  describe "GET /edit" do
    it "can get an edit page" do
      page = create(:page)

      get edit_event_page_url(page.event, page, as: user)

      expect(response).to have_http_status(:success)
    end

    it "gets the right page with a text box" do
      page = create(:page)

      get edit_event_page_url(page.event, page, as: user)

      doc = Nokogiri::HTML(response.body)

      expect(doc.css('input[type="text"][name="page[title]"]').attr("value").value).to eq(page.title)
      expect(doc.css("textarea").first.text.strip).to eq(page.body.strip)
    end

    it "has a submit button" do
      page = create(:page)

      get edit_event_page_url(page.event, page, as: user)

      expect(response.body).to include("submit")
    end

    it "gets a 404 when not signed in" do
      page = create(:page)

      get edit_event_page_url(page.event, page)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /pages/:page_id" do
    it "can edit the page and redirects to show the page" do
      page = create(:page)

      patch event_page_url(page.event, page, as: user), params: {page: {body: "# new body"}}

      expect(response).to have_http_status(:redirect)
      expect(response.redirect_url).to match(%r{.*/pages/#{page.id}$})

      page.reload
      expect(page.body).to eq("# new body")
    end

    context "with invalid parameters" do
      xit "renders a response with 422 status (i.e. to display the 'edit' template)" do
        page = create(:page)
        patch event_page_url(page.event, page, as: user), params: {page: {foo: "bar"}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested page" do
      page = create(:page)
      expect {
        delete event_page_url(page.event, page, as: user)
      }.to change(Page, :count).by(-1)
    end

    it "redirects to the pages list" do
      page = create(:page)
      delete event_page_url(page.event, page, as: user)
      expect(response).to redirect_to(event_pages_url(page.event))
    end
  end
end
