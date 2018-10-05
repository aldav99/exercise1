FactoryBot.define do
  sequence :body do |n|
    "answeranswer#{n}"
  end


  factory :answer do
    question
    user
    body
  end

  factory :invalid_answer, class: "Answer" do
    question
    user
    body { nil }
  end
end


