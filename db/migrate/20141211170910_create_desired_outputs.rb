class CreateDesiredOutputs < ActiveRecord::Migration
  def change
    create_table :desired_outputs do |t|
      t.integer :net_id, null: false
      t.integer :preset_input_id
      t.string :values, null: false
      t.string :name, null: false
    end
  end
end
