class ChangeShortStopDefenseFromHitters < ActiveRecord::Migration[6.1]
  def change
    remove_column :hitters, :shortstop_defense, :integer
    add_column :hitters, :shortstop_defense, :integer
  end
end
