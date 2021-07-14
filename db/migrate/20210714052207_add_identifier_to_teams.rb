class AddIdentifierToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :identifier, :string, null: false
    add_index :teams, :identifier, unique: true
  end
end
