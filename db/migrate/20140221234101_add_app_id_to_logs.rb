class AddAppIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :app_id, :integer
  end
end
