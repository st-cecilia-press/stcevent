require "rails_helper"

RSpec.describe 'GET /:slug', type: :request do
  it 'gets the right page' do
    page = create(:page, slug: 'testpage')

    get "/testpage"

    expect(response).to have_http_status(:success)
    expect(response.body).to include("<title>#{page.title}</title>")
  end

  it "gets the page for the current event"

  it "can get a page for a different event"
  
  it "converts markdown to html as expected"
end

