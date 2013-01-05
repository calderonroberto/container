class AddDisplayIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :display_id, :integer

    add_index :messages, :display_id
  end

  
end
