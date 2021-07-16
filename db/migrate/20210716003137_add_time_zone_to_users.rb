class AddTimeZoneToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :city, :string
    add_column :users, :time_zone, :string, null: false, default: 'UTC'
  end
end
