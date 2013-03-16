class AddUniqueIdToDisplays < ActiveRecord::Migration
  def change
    add_column :displays, :unique_id, :integer, :limit => 8

    add_index :displays, :unique_id

  end
end
