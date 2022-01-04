class TransactionsController < ApplicationController
  before_action :verify_authentication
  def create
    #transaction = Transaction.new(transaction_params)
    @transaction = TransactionCreator.new(transaction_params).call
   
     #if @transaction.transaction_type == "deposit"
       #conta = Account.find(transaction_params[:destination_account_id])

      # if @transaction.save
    #     conta.update(balance: conta.balance.to_f + transaction_params[:total_value].to_f)
        if !@transaction.id.nil?
          render json: @transaction, status: :created
      
        elsif
          render json:{}, status: 422
        end

    # elsif transaction.transaction_type == "withdraw"
    #   conta = Account.find(transaction_params[:origin_account_id])

    #   if conta.balance.to_f < transaction.total_value.to_f
        #render json: {message: "Saldo insuficiente"}

    #   elsif transaction.save
    #     conta.update(balance: conta.balance.to_f - transaction_params[:total_value].to_f)
    #     render json: transaction, status: :created
    #   end

    # elsif transaction.transaction_type == "transfers"
    #   origin = Account.find(transaction_params[:origin_account_id])
    #   destination = Account.find(transaction_params[:destination_account_id])

    #   if origin.balance.to_f < transaction.total_value.to_f
    #     render json: {erro_message: "Não possui saldo suficiente"}, status: 422

    #   else transaction.save
    #     origin.update(balance: origin.balance.to_f - transaction_params[:total_value].to_f)
    #     destination.update(balance: destination.balance.to_f + transaction_params[:total_value].to_f)
    #     render json: transaction, status: :created

    #   end
    # end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description,:total_value, :origin_account_id,:destination_account_id, :transaction_type)
  end
end