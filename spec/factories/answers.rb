FactoryBot.define do
  factory :answer do
    question
    user
    body { "MyText" }
    correct { true }
  end

  factory :invalid_answer, class: "Answer" do
    question
    user
    body { nil }
    correct { nil }
  end
end
