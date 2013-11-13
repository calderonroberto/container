class AddIndexToAppsName < ActiveRecord::Migration
  def change
    add_index :apps, :name, unique: true
  end
end
