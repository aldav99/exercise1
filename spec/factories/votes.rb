FactoryBot.define do
  factory :vote do
    vote { 1 }
    votable { nil }
    user { nil }
  end
end
