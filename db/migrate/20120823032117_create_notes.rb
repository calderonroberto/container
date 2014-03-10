class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :from
      t.string :message
      t.integer :display_id

      t.timestamps
    end

    add_index :notes, :from
    add_index :notes, :display_id
  end
end


