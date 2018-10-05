FactoryBot.define do
  factory :word do
    spelling { Forgery(:address).country }
  end
end
