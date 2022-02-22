require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it {is_expected.to validate_presence_of(:total_value)}
  it {is_expected.to belong_to(:origin_account).class_name("Account").optional(true)}
  it {is_expected.to belong_to(:destination_account).class_name("Account").optional(true)}
  it { is_expected.to define_enum_for(:transaction_type).with_values([:deposit, :withdraw, :transfers]) }
end
