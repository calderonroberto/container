class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :app_id
      t.integer :display_id

      t.timestamps
    end

    add_index :subscriptions, :app_id
    add_index :subscriptions, :display_id
  end
end
