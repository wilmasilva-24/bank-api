require 'rails_helper'
#valor, taxas de tranferencia, saldo tem que ser >= 0

RSpec.describe TransactionsController, type: :request do
  describe "create" do
    context "Realizar depósitos" do
      it "deve retornar status 201" do
        customer = Customer.create!(name:"Liam", cpf:"896452", access_token:"asdf")
        account = Account.create!(number:"8656", agency:"R4763", customer_id: customer.id)
        transaction_params = { transaction: {
          description: "Primeiro deposito",
          total_value: 200.00,
          transaction_type: "deposit",
          destination_account_id: account.id
          }
        }

        post "/transactions", params: transaction_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(201)
        expect(JSON.parse(response.body)).to include("total_value")
        expect(JSON.parse(response.body)).to include("destination_account_id")
      end
    end
    context "transação com dados invalidos" do
      it "deve retornar status 422" do
        customer = Customer.create!(name:"sky", cpf: rand(100..200) , access_token:"plç21")
        account = Account.create!(number: rand(100..200), agency:"g4785", customer_id: customer.id)
        invalid_params = { transaction: {
          description: "Dados incorretos",
          total_value: nil,
          transaction_type:"deposit",
          destination_account_id: account.id      
          }
        }

        post "/transactions", params: invalid_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["total_value"][0]).to eq("can't be blank")
      end
    end
    context "quando realizar o saque" do
      it "retorna os dados atualizados" do
        customer = Customer.create!(name:"Liam", cpf:"1234", access_token:"589")
        account = Account.create!(number:"8593", agency:"2538", balance: 500.00, customer_id: customer.id)
        withdraw_params = { transaction: {
          description: "Saque efetuado",
          total_value: 100.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
          }
        }

        post "/transactions", params: withdraw_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(JSON.parse(response.body)).to include("total_value")
        expect(JSON.parse(response.body)["total_value"]).to eq("100.0")
        expect(Account.last.balance.to_f).to eq(400.00)
      end
    end
    context "Quando não tiver saldo para saque" do
      it "deve retornar mensagem de erro " do
        customer = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account = Account.create!(number:"9841",agency:"K7789", balance: 300.00, customer_id: customer.id)
        invalid_params = { transaction:{
          description: "Novo saque",
          total_value: 700.00,
          transaction_type: "withdraw",
          origin_account_id: account.id
          }
        }

        post "/transactions", params: invalid_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(JSON.parse(response.body)["insuficient_balance"][0]).to eq("Saldo insuficiente.")
      end
    end
    context "Quando realizar transferência entre contas" do
      it "retornar status 201" do
        customer1 = Customer.create!(name:"Wilma", cpf:"57623", access_token:"lila")
        account1 = Account.create!(number:"9841", agency:"K7789", balance: 880.00, customer_id: customer1.id)
        customer2 = Customer.create!(name:"sky", cpf:"00531", access_token:"jklm")
        account2 = Account.create!(number:"1936", agency:"K7739", balance:200.00, customer_id: customer2.id)

        transfers_params = { transaction: {
          description: "Tranferencia realizada!",
          total_value: 300.00,
          transaction_type: "transfers",
          origin_account_id: account1.id,
          destination_account_id: account2.id
          }
        }

        post "/transactions", params: transfers_params, headers: {"ACCESS_TOKEN" => customer1.access_token}

        expect(response).to have_http_status(201)
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

        transfers_invalid = { transaction: {
          description: "Dados invalidos",
          total_value: 150.00,
          transaction_type: "transfers",
          origin_account_id: account2.id,
          destination_account_id: account1.id
          }
        }
        
        post "/transactions", params: transfers_invalid, headers: {"ACCESS_TOKEN" => customer2.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["insuficient_balance"][0]).to eq ("Saldo insuficiente.")

      end
    end
  end
end