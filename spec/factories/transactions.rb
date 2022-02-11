# This will guess the User class
FactoryBot.define do
  factory :transaction do
    description {"Tranferencia realizada!"}
    total_value {100.0}
    transaction_type {"transfers"}
    origin_account_id {nil}
    destination_account_id {nil}
  end
end