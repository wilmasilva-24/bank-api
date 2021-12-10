class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :agency
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
