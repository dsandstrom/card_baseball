class AddThrowsToPlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :players, :throws, :string
  end
end
