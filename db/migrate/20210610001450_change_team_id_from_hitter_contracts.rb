class ChangeTeamIdFromHitterContracts < ActiveRecord::Migration[6.1]
  def up
    change_column :hitter_contracts, :team_id, :integer, null: true
  end

  def down
    change_column :hitter_contracts, :team_id, :integer, null: false
  end
end
