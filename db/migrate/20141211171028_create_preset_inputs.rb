class CreatePresetInputs < ActiveRecord::Migration
  def change
    create_table :preset_inputs do |t|
      t.integer :net_id, null: false
      t.string :values, null: false
      t.string :name, null: false
    end
  end
end
