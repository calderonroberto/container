class AddRemoteIpToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :remote_ip, :string
  end
end
