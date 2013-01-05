class AddDefaultToApps < ActiveRecord::Migration
  def change
    change_column_default(:apps, :thumbnail_url, 'app_thumbnail.png')
  end
end
