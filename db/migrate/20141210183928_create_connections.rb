class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :parent_id
      t.integer :child_id
      t.float :weight
    end
  end
end
