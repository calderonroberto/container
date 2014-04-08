class AddInteractInstructionsToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :interact_instructions, :boolean
  end
end
