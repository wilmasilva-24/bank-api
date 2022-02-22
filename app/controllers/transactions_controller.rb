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

  def index
    origins = Transaction.only_origin_accounts(current_user)

    destinations = Transaction.only_destination_accounts(current_user)

    ids = origins.pluck(:id) + destinations.pluck(:id)
    
    transactions = Transaction.filter_by_date_interval(params[:start_date], params[:end_date]).where(id: [ids])

    render json: transactions, status: :ok

  end
  
  private

  def transaction_params
    params.require(:transaction).permit(:description,:total_value, :origin_account_id,:destination_account_id, :transaction_type)
  end
end