class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :user_id
      t.integer :from_id
      t.integer :gift_type, :default=>0

      t.timestamps
    end
  end
end
