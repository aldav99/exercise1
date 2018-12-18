FactoryBot.define do
  factory :comment do
    body { "test" }
  end

  factory :invalid_comment, class: "Comment" do
    body { nil }
  end
end