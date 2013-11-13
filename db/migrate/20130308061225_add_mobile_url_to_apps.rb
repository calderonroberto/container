class AddMobileUrlToApps < ActiveRecord::Migration
  def change
    add_column :apps, :mobile_url, :string
  end
end
