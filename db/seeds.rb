# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

raise StandardError, "Not for production use" if Rails.env.production?

require "factory_bot_rails"

module Seeds
  extend FactoryBot::Syntax::Methods

  create(:user, email: "nobody@default.invalid", password: "password")
  event = create(:event)
  create(:page, event: event, slug: "home")

  # Logistics
  logistics_menu = create(:menu, event: event, name: "Logistics")
  %w[directions staff tavern fees lodging].each_with_index do |slug, i|
    create(:page, event: event, slug: slug)
    create(:menu_item, menu: logistics_menu, name: slug.capitalize, url: "/#{slug}", order: i)
  end

  # Schedule - TODO

  # Classes and Activities
  classes_menu = create(:menu, event: event, name: "Classes & Activities")
  create(:menu_item, menu: classes_menu, name: "Classes", url: "/classes", order: 1)
  create(:menu_item, menu: classes_menu, name: "Teachers", url: "/teachers", order: 2)
  # classes
  # teachers
  %w[faq salon big_sing concert].each_with_index do |slug, i|
    create(:page, event: event, slug: slug)
    create(:menu_item, menu: classes_menu, name: slug.capitalize, url: "/#{slug}", order: i + 2)
  end

  # add some people & activities
  10.times do
    person = create(:person)
    create(:activity, facilitators: [person], event: event)
  end

  # Archives - TODO
end
