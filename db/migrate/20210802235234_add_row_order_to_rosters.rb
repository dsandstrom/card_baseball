class AddRowOrderToRosters < ActiveRecord::Migration[6.1]
  def change
    add_column :rosters, :row_order, :integer

    Roster.update_all('row_order = EXTRACT(EPOCH FROM created_at)')
  end
end
