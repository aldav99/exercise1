require 'rails_helper'

feature 'View answers', %q{
  View answers' list
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question_with_answers, title: "TestAnswerTest") }

  scenario 'Authenticated user is able to answers' do
    sign_in(user)

    click_on 'TestAnswerTest'

    expect(page).to have_content("answeranswer", count: 5)
  end
end