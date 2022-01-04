class TransactionCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
    @transaction = Transaction.new(@transaction_params)
  end

  def call
    if @transaction.transaction_type == "deposit"
      deposit = DepositCreator.new(@transaction).call

    elsif @transaction.transaction_type == "withdraw"
      conta = Account.find(@transaction.origin_account_id)
      if conta.balance.to_f < @transaction.total_value.to_f
        return @transaction

      elsif @transaction.save
        conta.update(balance: conta.balance.to_f - @transaction.total_value.to_f)

      end

    elsif @transaction.transaction_type == "transfers"
        origin = Account.find(@transaction.origin_account_id)
        destination = Account.find(@transaction.destination_account_id)
        if origin.balance.to_f < @transaction.total_value.to_f
          return @transaction

        elsif @transaction.save
          origin.update(balance: origin.balance.to_f - @transaction.total_value.to_f)
          destination.update(balance: destination.balance.to_f + @transaction.total_value.to_f)
        end
    end

    @transaction
  end
end