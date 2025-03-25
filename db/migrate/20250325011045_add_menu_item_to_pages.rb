class AddMenuItemToPages < ActiveRecord::Migration[8.0]
  def change
    add_reference :pages, :menu_item, null: true, foreign_key: true
    add_column :pages, :menu_order, :integer
  end
end
