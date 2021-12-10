class AddBalanceToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :balance, :decimal, default: 0.0
  end
end
