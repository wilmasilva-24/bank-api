require 'rails_helper'

RSpec.describe DepositCreator, type: :services do
  describe "call" do
    context "quando a transação for realizada" do
      it "precisa adicionar dinheiro na conta de destino" do
        customer = create(:customer)
        account = create(:account, customer: customer, balance: 100.00)
        transaction_valid = Transaction.new(
          description: "Primeiro deposito",
          total_value: 200.00,
          transaction_type: "deposit",
          destination_account_id: account.id
        )
        
        deposit = DepositCreator.new(transaction_valid).call
        
        expect(deposit.destination_account_id).to eq(account.id)
        expect(deposit.destination_account.balance.to_f).to eq(300.00)
      end
    end
  end
end