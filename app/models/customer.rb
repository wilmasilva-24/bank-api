class Customer < ApplicationRecord
    has_many :accounts
    validates :name, presence: true
    validates :cpf, presence: true, uniqueness: true
    
end
