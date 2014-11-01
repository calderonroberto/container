class AddCommunalPoolSizeToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :communal_pool_size, :integer, :default=>5
  end
end
