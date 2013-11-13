class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :from
      t.string :message

      t.timestamps
    end

    add_index :messages, :from
  end
end
