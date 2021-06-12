class ChangeCatcherBarFromHitters < ActiveRecord::Migration[6.1]
  def up
    change_column :hitters, :catcher_bar, :integer, default: nil
    change_column :hitters, :pitcher_bar, :integer, default: nil
  end

  def down
    change_column :hitters, :catcher_bar, :integer, default: 0
    change_column :hitters, :pitcher_bar, :integer, default: 0
  end
end
