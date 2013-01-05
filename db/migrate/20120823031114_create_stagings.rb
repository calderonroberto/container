class CreateStagings < ActiveRecord::Migration
  def change
    create_table :stagings do |t|
      t.integer :display_id
      t.integer :app_id

      t.timestamps
    end

    add_index :stagings, :app_id
    add_index :stagings, :display_id
  end
end
