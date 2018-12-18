require_relative 'acceptance_helper'

feature 'Create comment to answer', %q{
  I want to be able to add comment to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, title: "Privet!", user: user) }
  given(:answer) { create(:answer, question: question, body: "ANSWER") }

  scenario 'Authenticated user create the comment', js: true  do
    sign_in(user)

    visit question_path question

    fill_in 'Your answer', with: 'text text'
    click_on 'Create'
    
    within '.comment-answer-1' do 
      click_link 'Add comment'
      fill_in 'Your comment', with: 'My answer comment'
      click_on 'Create'
    end

    within '.comment-answer-1' do 
      expect(page).to have_content 'My answer comment'
    end
  end
end