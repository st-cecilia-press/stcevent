# remove old menu items table
class MigrateUsersToPeople < ActiveRecord::Migration[8.0]
  def up
    create_table :people do |t|
      t.string :name
      t.text :bio
      t.timestamps null: false
    end

    execute <<~EOT
      INSERT INTO people (id, name, bio, created_at, updated_at)
        SELECT u.id, 
               trim(concat(t.name, ' ', sca_first_name, ' ', sca_last_name)) AS name,
               bio,
               u.created_at, 
               u.updated_at
        FROM users u JOIN titles t ON u.title_id = t.id;
    EOT

    rename_table :teachers, :facilitations
    remove_foreign_key :facilitations, :users
    rename_column :facilitations, :user_id, :person_id
    change_column :facilitations, :person_id, :bigint
    add_foreign_key :facilitations, :people

    remove_foreign_key :staff_members, :users
    rename_column :staff_members, :user_id, :person_id
    change_column :staff_members, :person_id, :bigint
    add_foreign_key :staff_members, :people

    drop_table :users
  end

  def down
    raise "can't be reverted -- drops old user table"
  end
end
