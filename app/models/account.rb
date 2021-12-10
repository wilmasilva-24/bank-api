class Account < ApplicationRecord
    belongs_to :customer
    validates :number, uniqueness: true, presence: true
    validates :agency, presence: true
    has_many :origin_transactions, class_name: "Transaction", foreign_key: "origin_account_id"
    has_many :destination_transactions, class_name: "Transaction", foreign_key: "destination_account_id"
end
