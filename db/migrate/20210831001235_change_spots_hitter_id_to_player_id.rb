class ChangeSpotsHitterIdToPlayerId < ActiveRecord::Migration[6.1]
  def up
    add_column :spots, :player_id, :integer
    Spot.all.each do |spot|
      spot.update_column :player_id, spot.player_id
    end
    remove_column :spots, :hitter_id, :integer
  end

  def down
    add_column :spots, :hitter_id, :integer, null: false
    remove_column :spots, :player_id, :integer
  end
end
