class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
