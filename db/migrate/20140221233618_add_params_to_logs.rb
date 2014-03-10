class AddParamsToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :params, :text
  end
end
