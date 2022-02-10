# This will guess the User class
FactoryBot.define do
  factory :customer do
    sequence(:name) {|n| "customer #{n}" }
    cpf  { rand(100..200) }
    access_token { "asdf" }
  end
end