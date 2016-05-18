class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.float :value
      t.datetime :capture_time
      t.boolean :notified
      t.references :sensor, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
