class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.string :description
      t.decimal :total_value, default: 0
      t.references :origin_account, null: true, foreign_key: { to_table: 'accounts' }
      t.references :destination_account, null: true, foreign_key: { to_table: 'accounts' }
      t.integer :transaction_type, default: 0

      t.timestamps
    end
  end
end
