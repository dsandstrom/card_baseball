class ChangeTeamIdFromHitterContracts < ActiveRecord::Migration[6.1]
  def change
    change_column :hitter_contracts, :team_id, :integer, null: true
  end
end
