class TransactionsController < ApplicationController
  before_action :verify_authentication
  def create
    @transaction = TransactionCreator.new(transaction_params).call
   
    if !@transaction.id.nil?
      render json: @transaction, status: :created
  
    elsif
      render json: @transaction.errors.messages, status: 422
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description,:total_value, :origin_account_id,:destination_account_id, :transaction_type)
  end
end