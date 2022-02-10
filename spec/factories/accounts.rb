# This will guess the User class
FactoryBot.define do
    factory :account do
      sequence(:number) {|n| "number #{n}" }
      sequence(:agency) {|a| "agency #{a}" }
      balance {100.0}
      customer { nil }
    end
  end