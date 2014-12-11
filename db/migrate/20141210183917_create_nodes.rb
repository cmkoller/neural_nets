class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer :net_id
      t.integer :layer
      t.float :output, default: 0
      t.float :total_input, default: 0
    end
  end
end
