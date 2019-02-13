FactoryBot.define do
  sequence :body do |n|
    "answeranswer#{n}"
  end


  factory :answer do
    question
    user
    body
    correct {true}
    best {false}
  end

  factory :invalid_answer, class: "Answer" do
    question
    user
    body { nil }
  end

  factory :fix_answer, class: "Answer" do
    question
    user
    body { "body" }
    correct {true}
    best {false}
  end
end


