class WithdrawCreator
  def initialize(transaction)
    @transaction = transaction
    @conta = Account.find(@transaction.origin_account_id)
  end

  def call
    if have_balance
      
      make_withdraw
    else
      @transaction.errors.add(:insuficient_balance, "Saldo insuficiente.")
    end
    @transaction

  end

  private

  def have_balance
    @conta.balance.to_f > @transaction.total_value.to_f
   
  end

  def make_withdraw
    @transaction.save

    @conta.update(balance: @conta.balance.to_f - @transaction.total_value.to_f)
  end
end