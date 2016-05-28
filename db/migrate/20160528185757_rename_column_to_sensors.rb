class RenameColumnToSensors < ActiveRecord::Migration
  def change
    rename_column :sensors, :last_notification, :notification_window
  end
end
