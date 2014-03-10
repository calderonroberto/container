class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from
      t.string :message
      t.string :to

      t.timestamps
    end
    add_index :messages, :from
    add_index :messages, :to
  end
end
