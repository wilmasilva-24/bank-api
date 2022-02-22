require 'rails_helper'
#valor, taxas de tranferencia, saldo tem que ser >= 0

RSpec.describe TransactionsController, type: :request do
  describe "create" do
    context "Realizar depósitos" do
      it "deve retornar status 201" do
        customer = create(:customer)
        account = create(:account, customer: customer)
        transaction_params = attributes_for(
          :transaction, 
          description: "Primeiro deposito", 
          total_value: 200.00,
          transaction_type: "deposit",
          destination_account_id: account.id
        )       

        post "/transactions", params: {transaction: transaction_params}, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include("total_value")
        expect(JSON.parse(response.body)).to include("destination_account_id")
      end
    end
    context "transação com dados invalidos" do
      it "deve retornar status 422" do
        customer = create(:customer)
        account = create(:account, customer: customer)
        invalid_params = attributes_for( 
          :transaction,
          description: "Dados incorretos",
          total_value: nil,
          transaction_type:"deposit",
          destination_account_id: account.id      
        )          

        post "/transactions", params: {transaction: invalid_params}, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["total_value"][0]).to eq("can't be blank")
      end
    end
    context "quando realizar o saque" do
      it "retorna os dados atualizados" do
        customer = create(:customer)
        account = create(:account, balance: 500.00, customer: customer)
        withdraw_params = attributes_for(
          :transaction,
          description: "Saque efetuado",
          total_value: 100.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
        )

        post "/transactions", params: {transaction: withdraw_params}, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(JSON.parse(response.body)).to include("total_value")
        expect(JSON.parse(response.body)["total_value"]).to eq("100.0")
        expect(Account.last.balance.to_f).to eq(400.00)
      end
    end
    context "Quando não tiver saldo para saque" do
      it "deve retornar mensagem de erro " do
        customer = create(:customer)
        account = create(:account, balance: 300.00, customer: customer)
        invalid_params = attributes_for(
          :transaction,
          description: "Novo saque",
          total_value: 700.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
        )

        post "/transactions", params: {transaction: invalid_params}, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(JSON.parse(response.body)["insuficient_balance"][0]).to eq("Saldo insuficiente.")
      end
    end
    context "Quando realizar transferência entre contas" do
      it "retornar status 201" do
        customer1 = create(:customer)
        account1 = create(:account, balance: 880.00, customer: customer1)
        customer2 = create(:customer)
        account2 = create(:account, balance:200.00, customer: customer2)

        transfers_params = attributes_for(
          :transaction,
          description: "Tranferencia realizada!",
          total_value: 300.00,
          transaction_type: "transfers",
          origin_account_id: account1.id,
          destination_account_id: account2.id
        )

        post "/transactions", params: {transaction: transfers_params}, headers: {"ACCESS_TOKEN" => customer1.access_token}

        expect(response).to have_http_status(201)
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

        transfers_invalid = attributes_for(
          :transaction,
          description: "Dados invalidos",
          total_value: 150.00,
          transaction_type: "transfers",
          origin_account_id: account2.id,
          destination_account_id: account1.id
        )
        
        post "/transactions", params: {transaction: transfers_invalid}, headers: {"ACCESS_TOKEN" => customer2.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["insuficient_balance"][0]).to eq ("Saldo insuficiente.")

      end
    end
    context "Extrato com filtro de data de inicio e final" do
      it "retornar status 200" do
        customer = create(:customer)
        account = create(:account, balance: 500.00, customer: customer)

        customer2 = create(:customer)
        account2 = create(:account, balance: 50.00, customer: customer2)

        deposit = create(:transaction, total_value: 200.00, transaction_type: "deposit",destination_account_id: account.id, created_at:"2022-10-01")
        withdraw = create(:transaction, total_value: 500.00, transaction_type: "withdraw",destination_account_id: account.id, created_at:"2022-10-27")
        transfers = create(:transaction, total_value: 100.00, transaction_type: "transfers", origin_account_id: account.id, destination_account_id: account2.id, created_at:"2022-11-01")
        withdraw = create(:transaction, total_value: 50.00, transaction_type: "withdraw",destination_account_id: account2.id, created_at:"2022-11-10")

        get "/transactions/", params: {start_date: "2022-09-01", end_date: "2022-11-02"}, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)[0]["total_value"]).to eq ("200.0")
        expect(JSON.parse(response.body).count).to eq(3)
            

      end
    end
  end
end