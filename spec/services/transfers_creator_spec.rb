require 'rails_helper'

RSpec.describe TransfersCreator, type: :services do
  describe "call" do
    context "Quando realizar transferência entre contas" do
      it "Transferencia efetuada" do
        customer1 = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account1 = Account.create!(number:"9841", agency:"K7789", balance: 880.00, customer_id: customer1.id)
        customer2 = Customer.create!(name:"sky", cpf:"00531", access_token:"jklm")
        account2 = Account.create!(number:"1936", agency:"K7739", balance:200.00, customer_id: customer2.id)
        
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
        customer1 = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account1 = Account.create!(number:"9841", agency:"K7789", balance: 100.00, customer_id: customer1.id)
        customer2 = Customer.create!(name:"sky", cpf:"00531", access_token:"jklm")
        account2 = Account.create!(number:"1936", agency:"K7739", balance:50.00, customer_id: customer2.id)

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