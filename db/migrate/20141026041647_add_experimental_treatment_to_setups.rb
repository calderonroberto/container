class AddExperimentalTreatmentToSetups < ActiveRecord::Migration
  def change
    add_column :setups, :experimental_setup, :integer, :default=>0
  end
end
