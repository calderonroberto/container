class AddTokenThumbnailPictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :text
    add_column :users, :thumbnail_url, :string
    add_column :users, :picture_url, :string
    add_column :users, :friends, :text
  end
end
