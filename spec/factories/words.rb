FactoryBot.define do
  factory :word do
    spelling { Forgery('basic').password }
  end
end
