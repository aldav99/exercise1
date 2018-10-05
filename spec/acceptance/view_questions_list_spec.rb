require 'rails_helper'

feature 'View questions', %q{
  View question
} do

  given(:user) { create(:user_with_questions) }


  scenario 'Authenticated user is able to view questions' do
    sign_in(user)

    expect(page).to have_content("questionquestion", count: 10)
  end
end