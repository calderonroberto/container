class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :controller
      t.string :method
      t.integer :user_id
      t.integer :display_id

      t.timestamps
    end
  end
end
