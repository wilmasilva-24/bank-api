require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { Account.new(number: "789") }
  it {is_expected.to belong_to(:customer)}
  it {is_expected.to validate_uniqueness_of(:number).case_insensitive}
  it {is_expected.to validate_presence_of(:number)}
  it {is_expected.to validate_presence_of(:agency)}
  it {is_expected.to have_many(:origin_transactions).class_name("Transaction").with_foreign_key("origin_account_id")}
  it {is_expected.to have_many(:destination_transactions).class_name("Transaction").with_foreign_key("destination_account_id")}
end