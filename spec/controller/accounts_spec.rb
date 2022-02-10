require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  describe "#create" do
    context "Quando cadastrar nova conta" do
      it "deve retornar status 201" do
        customer = create(:customer)
        account_params = { account: attributes_for(:account, customer_id: customer.id)}

        post "/accounts", params: account_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(201)
      end

      it "deve retornar os dados da conta" do
        customer = create(:customer)
        return_params = { account: attributes_for(:account, customer_id: customer.id)}

        post "/accounts", params: return_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(JSON.parse(response.body)).to include("number")
        expect(JSON.parse(response.body)).to include("agency")
      end
    end

    context "Quando não cadastrar uma conta" do
      it "deve retornar status 422" do
        customer = create(:customer)
        invalid_params = { account: attributes_for(:account, agency: nil, customer_id: customer.id)}

        post "/accounts", params: invalid_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to include("agency")
        expect(JSON.parse(response.body)["agency"][0]).to eq("can't be blank")

      end
    end
  end
  describe "#update" do
    context "Quando atualizar a conta" do
      it "deve retornar status 204" do
        customer = create(:customer)
        account = create(:account, customer: customer)
        update_params = { account: attributes_for(:account, agency:"r8566")}
        
        put "/accounts/#{account.id}", params: update_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(204)
        expect(Account.last.agency).to eq(update_params[:account][:agency])

      end
    end
    context "quando não atualizar" do
      it "deve retornar status 422" do
        customer = create(:customer)
        account = create(:account, customer: customer)
        update_params = { account: attributes_for(:account, number: nil)}

        put "/accounts/#{account.id}", params: update_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["number"][0]).to eq("can't be blank")

      end
    end
  end
  describe "#destroy" do
    context "quando encerrar uma conta" do
      it "retornar status 422" do
        customer = create(:customer)
        account = create(:account, customer: customer)

        delete "/accounts/#{account.id}", headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eq('conta não pode ser excluida')
       
      end
    end
  end
  describe "#show" do
    context "Solicitar saldo" do
      it "deve retornar status 200" do
        customer = create(:customer)
        account = create(:account, balance: 385.58, customer: customer)

        get "/accounts/#{account.id}", headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["balance"]).to eq("385.58")
        expect(Account.last.balance.to_f).to eq(385.58)
      end
    end
    context "quando informar uma conta que não existe" do
      it "deve retornar status 422" do
        customer = create(:customer)
        invalid_account = "invalid"
        

        get "/accounts/#{invalid_account}", headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["erro_message"]).to eq("\"Couldn't find Account with 'id'=invalid\"")

      end
    end
  end
end