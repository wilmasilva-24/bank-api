class Transaction < ApplicationRecord
  validates :total_value, presence: true
  belongs_to :origin_account, class_name: "Account", optional: true
  belongs_to :destination_account, class_name: "Account", optional: true
  enum transaction_type: { deposit: 0, withdraw: 1, transfers: 2 }

  scope :only_origin_accounts, -> (user) do 
    joins("INNER JOIN accounts as a ON transactions.origin_account_id = a.id")
    .where("a.customer_id = :customer_id", customer_id: user)
  end

  scope :only_destination_accounts, -> (user) do
    joins("INNER JOIN accounts as d ON transactions.destination_account_id = d.id")
    .where("d.customer_id = :customer_id", customer_id: user)
  end

  scope :filter_by_date_interval, -> (date_init, date_finish) do
    where("date(transactions.created_at) between :start_date and :end_date", 
    start_date: date_init.to_date, end_date: date_finish.to_date
    )
  end
end
