class CreateMenuItems < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.integer :order
      t.text :name
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
