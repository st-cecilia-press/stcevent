# remove old menu items table
class RedefineMenuItems < ActiveRecord::Migration[8.0]
  def up
    drop_table :menu_items

    create_table :menus do |t|
      t.integer :order
      t.string :name
      t.references :event
      t.timestamps null: false
    end

    create_table :menu_items do |t|
      t.integer :order
      t.string :name
      t.string :url
      t.references :menu
      t.timestamps null: false
    end
  end

  def down
    raise "can't be reverted -- drops old menu item table"
  end
end
