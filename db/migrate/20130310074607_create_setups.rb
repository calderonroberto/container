class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.string :thingbroker_url, :default => 'http://kimberly.magic.ubc.ca:8080/thingbroker'
      t.integer :display_id

      t.timestamps
    end
  end
end
