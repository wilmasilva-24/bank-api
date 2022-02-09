require 'rails_helper'

RSpec.describe TransactionCreator, type: :services do
  describe "#call" do
    context "quando transaction_type for igual a deposito" do
      it "precisa adicionar dinheiro na conta de destino" do
        customer = Customer.create!(name:"Liam", cpf:"896452", access_token:"asdf")
        account = Account.create!(number:"8656", agency:"R4763", customer_id: customer.id, balance: 100.00)
        transaction_params = {
          description: "Primeiro deposito",
          total_value: 200.00,
          transaction_type: "deposit",
          destination_account_id: account.id
          
        }

        transaction = TransactionCreator.new(transaction_params).call

        expect(Account.last.balance).to eq(300.00)
      end
    end

    context "quando tiver saldo para saque" do
      it "deve retirar dinheiro na conta" do
        customer = Customer.create!(name:"Liam", cpf:"1234", access_token:"589")
        account = Account.create!(number:"8593", agency:"2538", balance: 500.00, customer_id: customer.id)
        withdraw_params = { 
          description: "Saque efetuado",
          total_value: 100.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
          
        }

        transaction = TransactionCreator.new(withdraw_params).call
      
        expect(Account.last.balance.to_f).to eq(400.00)
        expect(transaction.total_value.to_f).to eq(100.00)

      end
    end

    context "Quando não tiver saldo para saque" do
      it "saldo da conta deve permanencer igual" do
        customer = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account = Account.create!(number:"9841",agency:"K7789", balance: 300.00, customer_id: customer.id)
        invalid_params = { 
          description: "Novo saque",
          total_value: 700.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
          
        }

        transaction = TransactionCreator.new(invalid_params).call

        expect(Account.last.balance.to_s).to eq("300.0")

      end
    end
    context "Quando realizar transferência entre contas" do
      it "Transferencia efetuada" do
        customer1 = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account1 = Account.create!(number:"9841", agency:"K7789", balance: 880.00, customer_id: customer1.id)
        customer2 = Customer.create!(name:"sky", cpf:"00531", access_token:"jklm")
        account2 = Account.create!(number:"1936", agency:"K7739", balance:200.00, customer_id: customer2.id)

        transfers_params = {
          description: "Tranferencia realizada!",
          total_value: 300.00,
          transaction_type: "transfers",
          origin_account_id: account1.id,
          destination_account_id: account2.id
          
        }

        transaction = TransactionCreator.new(transfers_params).call

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

        transfers_invalid = {
          description: "Dados invalidos",
          total_value: 150.00,
          transaction_type: "transfers",
          origin_account_id: account2.id,
          destination_account_id: account1.id
          
        }
        
        transaction = TransactionCreator.new(transfers_invalid).call
        
        expect(Account.last.balance.to_f).to eq(50.0)
      
      end
    end
    context "Quando passar uma tranação inexistente" do
      it "Tipo de transação inválida" do
        customer1 = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account1 = Account.create!(number:"9841", agency:"K7789", balance: 100.00, customer_id: customer1.id)
        customer2 = Customer.create!(name:"sky", cpf:"00531", access_token:"jklm")
        account2 = Account.create!(number:"1936", agency:"K7739", balance:50.00, customer_id: customer2.id)

        type_transfers = {
          description: "Dados invalidos",
          total_value: 150.00,
          transaction_type: nil,
          origin_account_id: account1.id,
          destination_account_id: account2.id
          
        }

        transaction = TransactionCreator.new(type_transfers).call

        expect(transaction.errors.messages[:type_invalid][0]).to eq("Tipo de transação inválida.")

      end
    end
  end
end
