class AddTokenToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :access_token, :string
  end
end
