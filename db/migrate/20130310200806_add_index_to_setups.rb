class AddIndexToSetups < ActiveRecord::Migration
  def change
    add_index :setups, :display_id
  end
end
