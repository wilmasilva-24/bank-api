require 'rails_helper'

RSpec.describe TransfersCreator, type: :services do
  describe "call" do
    context "Quando realizar transferência entre contas" do
      it "Transferencia efetuada" do
        customer1 = create(:customer)
        account1 = create(:account, balance: 880.00, customer: customer1)
        customer2 = create(:customer)
        account2 = create(:account, balance:200.00, customer: customer2)
        
        transfers_params = Transaction.new(
          description: "Tranferencia realizada!",
          total_value: 300.00,
          transaction_type: "transfers",
          origin_account_id: account1.id,
          destination_account_id: account2.id
        )
        
        transfers = TransfersCreator.new(transfers_params).call
        
        expect(Account.first.balance.to_f).to eq(580.00)
        expect(Account.last.balance.to_f).to eq(500.00)       
      end
    end
    context "dados invalidos na transferência" do
      it "retornar status 422" do
        customer1 = create(:customer)
        account1 = create(:account, balance: 100.00, customer: customer1)
        customer2 = create(:customer)
        account2 = create(:account, balance:50.00, customer: customer2)

        transfers_invalid = Transaction.new(
          description: "Dados invalidos",
          total_value: 150.00,
          transaction_type: "transfers",
          origin_account_id: account2.id,
          destination_account_id: account1.id
        )
        
        transfers = TransfersCreator.new(transfers_invalid).call
     
        expect(Account.last.balance.to_f).to eq(50.0)
        expect(transfers.errors.messages[:insuficient_balance][0]).to eq("Saldo insuficiente.")
      end
    end
  end
end