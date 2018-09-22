FactoryBot.define do
  factory :answer do
    question
    body { "MyText" }
    correct { true }
  end

  factory :invalid_answer, class: "Answer" do
    question
    body { nil }
    correct { nil }
  end
end
