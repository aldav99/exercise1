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
        answers_count { 2 }
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

  factory :fix_question, class: "Question" do
    user
    title { "title" }
    body { "body" }
  end

  factory :question_with_subscriber, class: "Question" do
    user
    title { "title" }
    body { "body" }
    after(:create) do |question, user|
      Subscriber.create(user_id: user.id, question_id: question.id)
    end
  end
end
