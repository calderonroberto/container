class CreateFavours < ActiveRecord::Migration
  def change
    create_table :favours do |t|
      t.integer :from_id
      t.integer :to_id
      t.boolean :reciprocated, :default => false

      t.timestamps
    end
  end
end
