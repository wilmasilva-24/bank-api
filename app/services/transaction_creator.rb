class TransactionCreator
  def initialize(transaction_params)
    @transaction_params = transaction_params
    @transaction = Transaction.new(@transaction_params)
  end

  def call
    if @transaction.transaction_type == "deposit"
      deposit = DepositCreator.new(@transaction).call

    elsif @transaction.transaction_type == "withdraw"
      withdraw = WithdrawCreator.new(@transaction).call

    elsif @transaction.transaction_type == "transfers"
      transfers = TransfersCreator.new(@transaction).call

    else
      @transaction.errors.add(:type_invalid, "Tipo de transação inválida.")

    end

    @transaction
  end
end