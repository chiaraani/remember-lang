FactoryBot.define do
  factory :word do
    spelling { Forgery(:basic).color }
  end
end
