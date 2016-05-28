class AddThresholdToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :notification, :integer
    add_column :sensors, :notification_value, :integer
    add_column :sensors, :notification_count, :integer
    add_column :sensors, :last_notification, :datetime
  end
end
