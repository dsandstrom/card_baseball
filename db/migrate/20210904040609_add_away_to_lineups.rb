class AddAwayToLineups < ActiveRecord::Migration[6.1]
  def change
    add_column :lineups, :away, :boolean, default: true
  end
end
