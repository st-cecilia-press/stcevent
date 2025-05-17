class AddShortNameToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :short_name, :string
  end
end
