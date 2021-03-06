require 'rails_helper'
 #quando a conta existir
    #recebe o cpf pelo strong params
    #busca a conta pelo cpf informado
    #gera um novo token
    #atualiza a coluna access_token dessa conta
    #retorna o objeto json dessa conta

RSpec.describe AuthenticationsController, type: :request do
  describe '#sign_in' do
    context 'quando informar os dados' do
      it 'deve retornar status 200' do
        customer = create(:customer, cpf:"86572")
        account = create(:account, customer_id: customer.id)
        authentication_params = { "customer": { 
          "cpf": customer.cpf,
          account_id: account.id
          }
        }

        post '/authentications/sign_in', params: authentication_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("access_token")
      end
    end
    context 'quando informar dados invalidos' do
      it 'deve retornar status 422' do
        customer = create(:customer, name:"Liam")
        account = create(:account, customer_id: customer.id)
        invalid_params = { "customer": {
          "name": customer.name,
          account_id: account.id
          }
        }

        post '/authentications/sign_in', params: invalid_params

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['erro_message']).to eq('informe dados válidos')

      end
    end
  end
  describe '#sign_out' do
    context 'para deslogar' do
      it 'deve retornar status 204' do
        customer = create(:customer)

        delete '/authentications/sign_out', headers: {'ACCESS_TOKEN' => customer.access_token}

        expect(response).to have_http_status(:no_content)
      end
    end
    
    context 'tentando acessar o endpoint sem o usuário logado' do
      it 'deve retornar status 401' do
        customer = create(:customer, access_token:nil)

        delete '/authentications/sign_out', headers: {'ACCESS_TOKEN' => customer.access_token}

        expect(response).to have_http_status(401)
      end
    end
  end
end

   