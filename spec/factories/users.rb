FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password {"12345678"}
    password_confirmation {"12345678"}

    factory :user_with_answers do
      transient do
        answers_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:answer, evaluator.answers_count, user: user)
      end
    end

    factory :user_with_questions do
      transient do
        questions_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end
  end
end

