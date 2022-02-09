require 'rails_helper'

RSpec.describe WithdrawCreator, type: :services do
  describe "call" do
    context "quando tiver saldo para saque" do
      it "deve retirar dinheiro na conta" do
        customer = Customer.create!(name:"Liam", cpf:"1234", access_token:"589")
        account = Account.create!(number:"8593", agency:"2538", balance: 500.00, customer_id: customer.id)
        withdraw_params = Transaction.new( 
          description: "Saque efetuado",
          total_value: 100.00,
          transaction_type: "withdraw",
          origin_account_id: account.id     
        )

        withdraw = WithdrawCreator.new(withdraw_params).call
      
        expect(Account.last.balance.to_f).to eq(400.00)
        expect(withdraw.total_value.to_f).to eq(100.00)

      end
    end
    context "Quando não tiver saldo para saque" do
      it "saldo da conta deve permanencer igual" do
        customer = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account = Account.create!(number:"9841",agency:"K7789", balance: 300.00, customer_id: customer.id)
        invalid_params = Transaction.new(
          description: "Novo saque",
          total_value: 700.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
        )
        
        withdraw = WithdrawCreator.new(invalid_params).call
        
        expect(account.balance.to_f).to eq(300.0)

      end
    end
  end
end