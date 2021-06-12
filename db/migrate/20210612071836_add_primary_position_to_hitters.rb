class AddPrimaryPositionToHitters < ActiveRecord::Migration[6.1]
  def change
    add_column :hitters, :primary_position, :integer, null: false
    add_column :hitters, :hitting_pitcher, :boolean, default: false
    add_index :hitters, :primary_position
  end
end
