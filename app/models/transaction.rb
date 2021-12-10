class Transaction < ApplicationRecord
  validates :total_value, presence: true
  belongs_to :origin_account, class_name: "Account", optional: true
  belongs_to :destination_account, class_name: "Account", optional: true
  enum transaction_type: { deposit: 0, withdraw: 1, transfers: 2 }
end
