class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :user_id
      t.integer :display_id

      t.timestamps
    end

    add_index :registrations, :user_id
    add_index :registrations, :display_id

  end
end
