FactoryBot.define do

  sequence :title do |n|
    "questionquestion#{n}"
  end

  factory :question do
    user
    title
    body { "MyText" }

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: "Question" do
    user
    title { nil }
    body { nil }
  end
end
