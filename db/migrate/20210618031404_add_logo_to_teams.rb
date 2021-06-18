class AddLogoToTeams < ActiveRecord::Migration[6.1]
  def change
    remove_column :teams, :icon, :string
    add_column :teams, :logo, :string
  end
end
