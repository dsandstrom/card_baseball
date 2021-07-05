class AddRowOrderToLeagues < ActiveRecord::Migration[6.1]
  def change
    add_column :leagues, :row_order, :integer
  end
end
