class AddTestGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :test_group, :integer, :default=>0
  end
end
