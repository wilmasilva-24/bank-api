class AccountsController < ApplicationController
  before_action :verify_authentication
  def create
      account = Account.new(account_params)

      if account.save
        render json: account, status: 201
      else
        render json: account.errors, status: 422
      end
  end

  def update
    account = Account.find(params[:id])

    if account.update(account_params)
      render json: account, status: 204
    else
      render json: account.errors, status: 422
    end
  end

  def destroy
    render json: {message: 'conta não pode ser excluida'}, status: 422
    
  end

  def show
    account = Account.find(params[:id])
    
    render json: account, status: 200

    rescue ActiveRecord::RecordNotFound => error
      render json: {erro_message: error.to_json}, status: 422
  
  end

  private

  def account_params
      params.require(:account).permit(:number,:agency,:customer_id)
  end
end