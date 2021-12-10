class AuthenticationsController < ApplicationController
  before_action :verify_authentication, except: :sign_in
  def sign_in
    if customer = Customer.find_by(cpf: authentication_params[:cpf])
      customer.update(access_token: SecureRandom.hex(10))

      render json: customer, status: 200
    else
      render json: {erro_message: 'informe dados válidos'}, status: 422
    end
  end

  def sign_out
    customer = Customer.find_by(access_token: request.headers["ACCESS_TOKEN"])
    customer.update(access_token: nil)
    head :no_content
  end

  private

  def authentication_params
    params.require(:customer).permit(:cpf)
  end
end