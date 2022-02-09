class TransfersCreator
  def initialize(transaction)
    @transaction = transaction
    @origin = Account.find(@transaction.origin_account_id)
    @destination = Account.find(@transaction.destination_account_id)
  end
  
  def call
    if have_balance

      make_transfers
    else
      @transaction.errors.add(:insuficient_balance, "Saldo insuficiente.")

    end
    
    @transaction
  end

  private
  def have_balance
    @origin.balance.to_f > @transaction.total_value.to_f
  
  end

  def make_transfers  
    @transaction.save

    @origin.update(balance: @origin.balance.to_f - @transaction.total_value.to_f)
    @destination.update(balance: @destination.balance.to_f + @transaction.total_value.to_f)
  end
end