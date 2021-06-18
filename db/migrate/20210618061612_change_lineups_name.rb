class ChangeLineupsName < ActiveRecord::Migration[6.1]
  def up
    change_column :lineups, :name, :string, null: true
  end

  def down
    change_column :lineups, :name, :string, null: false
  end
end
