class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :name
      t.integer :unit
      t.integer :kind
      t.boolean :public
      t.integer :type_of_graph
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
