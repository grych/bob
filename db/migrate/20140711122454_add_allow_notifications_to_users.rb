class AddAllowNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allow_notifications, :boolean, default: true
  end
end
