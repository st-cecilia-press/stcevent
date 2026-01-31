require "rails_helper"

RSpec.describe "/events/:event_id", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  describe "GET /event/:event_id/edit" do
    it "shows each menu in a form" do
      menus = 2.times.map { create(:menu, event_id: event.id) }

      get edit_event_url(event.id, as: user)

      menus.each_with_index do |menu, index|
        expect(response.body).to include(menu.name)
        expect(response.body).to match("event_menus_attributes_#{index}_name")
      end
    end

    it "shows menus in order" do
      [
        create(:menu, order: 99, name: "The last one", event_id: event.id),
        create(:menu, order: 1, name: "The first one", event_id: event.id)
      ]

      get edit_event_url(event.id, as: user)

      expect(response.body).to match(/The first one.*The last one/m)
    end

    it "shows menu items" do
      menu = create(:menu, event_id: event.id)
      menu_items = 3.times.map { create(:menu_item, menu_id: menu.id) }

      get edit_event_url(event.id, as: user)

      menu_items.each_with_index do |menu_item, index|
        expect(response.body).to include(menu_item.name)
        expect(response.body).to match("event_menus_attributes_0_menu_items_attributes_#{index}_name")
      end
    end

    it "shows menu items in order" do
      menu = create(:menu, event_id: event.id)

      [
        create(:menu_item, order: 99, name: "The last one", menu_id: menu.id),
        create(:menu_item, order: 1, name: "The first one", menu_id: menu.id)
      ]

      get edit_event_url(event.id, as: user)

      expect(response.body).to match(/The first one.*The last one/m)
    end

    it "shows an empty menu" do
      get edit_event_url(event.id, as: user)

      expect(response.body).to match(/event_menus_attributes_0/)
    end

    it "shows an empty menu item for an existing menu" do
      create(:menu, event_id: event.id)

      get edit_event_url(event.id, as: user)

      expect(response.body).to match("event_menus_attributes_0_menu_items_attributes_0_name")
    end
  end

  describe "PATCH /event/:event_id/update" do
    it "updates the menus for the events" do
      menus = 2.times.map { create(:menu, event_id: event.id) }

      patch event_url(event.id, as: user), params: {
        event: {
          menus_attributes:
          [
            {id: menus[0].id, order: 99, name: "New Name"},
            {id: menus[1].id, order: 100, name: "Another Name"}
          ]
        }
      }

      menus.each(&:reload)

      expect(menus.map(&:name)).to contain_exactly("New Name", "Another Name")
      expect(menus.map(&:order)).to contain_exactly(99, 100)
    end

    it "updates the menu items" do
      menu = create(:menu, event_id: event.id)
      menu_items = 3.times.map { create(:menu_item, menu_id: menu.id) }

      patch event_url(event.id, as: user), params: {
        event: {
          menus_attributes:
          [
            {
              id: menu.id,
              order: menu.order,
              name: menu.name,
              menu_items_attributes: [
                {id: menu_items[0].id, order: 99, name: "A Name", url: "/foo"},
                {id: menu_items[1].id, order: 100, name: "Another Name", url: "/bar"},
                {id: menu_items[2].id, order: 101, name: "A Third Name", url: "/baz"}
              ]
            }
          ]
        }
      }

      menu_items.each(&:reload)

      expect(menu_items.map(&:name)).to contain_exactly("A Name", "Another Name", "A Third Name")
      expect(menu_items.map(&:order)).to contain_exactly(99, 100, 101)
      expect(menu_items.map(&:url)).to contain_exactly("/foo", "/bar", "/baz")
    end

    # TODO -- need to disable validation/reject_if and see this actually create an empty menu item.
    # May want to temporarily disable the sorting so we don't get the
    # comparison with nil issue & can actually blank empty menus/menu items

    it "doesn't create an empty menu" do
      patch event_url(event.id, as: user), params: {
        event: {
          menus_attributes:
          [
            attributes_for(:menu),
            {order: "", name: ""}
          ]
        }
      }

      event.reload
      expect(event.menus.count).to eq 1
    end

    it "doesn't create an empty menu item" do
      menu = create(:menu, event_id: event.id)

      patch event_url(event.id, as: user), params: {
        event: {
          menus_attributes:
          [
            menu.attributes.merge({
              menu_items_attributes: [
                attributes_for(:menu_item),
                {order: "", name: "", url: ""}
              ]
            })
          ]
        }
      }

      menu.reload
      expect(menu.menu_items.count).to eq 1
    end

    it "deletes menus and their dependents" do
      menu = create(:menu, event_id: event.id)
      menu_item = create(:menu_item, menu_id: menu.id)

      expect(Menu.count).to eq 1
      expect(MenuItem.count).to eq 1

      patch event_url(event.id, as: user), params: {
        event: {
          menus_attributes:
          [
            menu.attributes.merge({
              _destroy: 1,
              menu_items_attributes: [menu_item.attributes]
            })
          ]
        }
      }

      expect(Menu.count).to eq 0
      expect(MenuItem.count).to eq 0
    end
  end
end
