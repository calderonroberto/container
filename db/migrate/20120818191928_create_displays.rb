class CreateDisplays < ActiveRecord::Migration
  def change
    create_table :displays do |t|
      t.string :name
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
    add_index :displays, [:remember_token, :name]
  end
end
