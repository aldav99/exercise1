require_relative 'acceptance_helper'

feature 'Can do search', %q{
  I want to be able to search
} do

  # given(:user) { create(:user) }
  # given(:question) { create(:question, title: "Privet!", user: user) }
  # given(:answer) { create(:answer, question: question, body: "ANSWER") }
  let!(:questions) { create_list(:question, 2) }

  # scenario 'Authenticated user create the comment', js: true  do
  #   sign_in(user)

  #   visit question_path question

  #   fill_in 'Your answer', with: 'text text'
  #   click_on 'Create'
    
  #   within '.comment-answer-1' do 
  #     click_link 'Add comment'
  #     fill_in 'Your comment', with: 'My answer comment'
  #     click_on 'Create'
  #   end

  #   within '.comment-answer-1' do 
  #     expect(page).to have_content 'My answer comment'
  #   end
  # end


  scenario 'Authenticate user find questions', js: true do
    ThinkingSphinx::Test.run do
      index
      sign_in(user)
      visit questions_path
      fill_in 'anything_query', with: 'questionquestion'
      click_on 'Search'
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end
end