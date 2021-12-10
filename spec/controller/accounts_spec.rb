require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  describe "#create" do
    context "Quando cadastrar nova conta" do
      it "deve retornar status 201" do
        customer = Customer.create!(name:"Wilma", cpf:"175699", access_token:"233")
        account_params = { account: {
          number:"d45879",
          agency:"3758-9",
          customer_id: customer.id
          }
        }

        post "/accounts", params: account_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(201)
      end

      it "deve retornar os dados da conta" do
        customer = Customer.create!(name:"Wilma", cpf:"175699", access_token:"123")
        return_params = { account: {
            number:"d45879",
            agency:"3758-9",
            customer_id: customer.id
          }
        }
        post "/accounts", params: return_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(JSON.parse(response.body)).to include("number")
        expect(JSON.parse(response.body)).to include("agency")
      end
    end

    context "Quando não cadastrar uma conta" do
      it "deve retornar status 422" do
        customer = Customer.create!(name:"Wilma", cpf:"175699", access_token:"786")
        invalid_params = { account: {
            number:"t78962",
            agency: nil,
            customer_id: customer.id
          }
        }
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
        customer = Customer.create!(name:"Wilma", cpf:"175699", access_token:"132")
        account = Account.create!(number:"87963", agency:"t7523", customer_id: customer.id)
        update_params = { account: {
          agency:"r8566"
          }
        }
        
        put "/accounts/#{account.id}", params: update_params, headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(204)
        expect(Account.last.agency).to eq(update_params[:account][:agency])

      end
    end
    context "quando não atualizar" do
      it "deve retornar status 422" do
        customer = Customer.create!(name:"Lila", cpf:"98760", access_token:"16274")
        account = Account.create!(number:"03756", agency:"l00124", customer_id: customer.id)
        update_params = { account: {
          number: nil
          }
        }

        put "/accounts/#{account.id}", params: update_params, headers: {"ACCESS_TOKEN" => customer.access_token}
        
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["number"][0]).to eq("can't be blank")

      end
    end
  end
  describe "#destroy" do
    context "quando encerrar uma conta" do
      it "retornar status 422" do
        customer = Customer.create!(name:"Wilma", cpf:"87523", access_token:"7824")
        account = Account.create!(number:"03756", agency:"l00124", customer_id: customer.id)

        delete "/accounts/#{account.id}", headers: {"ACCESS_TOKEN" => customer.access_token}

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['message']).to eq('conta não pode ser excluida')
       
      end
    end
  end
end