class AddUrlUploadedToApps < ActiveRecord::Migration
  def change
     add_attachment :apps, :url_uploaded
     add_attachment :apps, :mobile_url_uploaded
  end
end
