class DepositCreator
  def initialize(transaction)
    @transaction = transaction
    @conta = Account.find(@transaction.destination_account_id)
  end

  def call
    make_deposit
      
    @transaction
  end 

  private

  def make_deposit 
    @transaction.save
    
    @conta.update(balance: @conta.balance.to_f + @transaction.total_value.to_f)
  end
end