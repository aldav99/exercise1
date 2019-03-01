require_relative 'acceptance_helper'
require 'rake'
require 'thinking_sphinx/tasks'

feature 'Can do search', %q{
  I want to be able to search
} do

  let!(:user) { create(:user) }
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
      # index
      ThinkingSphinx::Test.index
      sign_in(user)
      # visit questions_path
      # save_and_open_page
      # within('.new_search') do
        fill_in 'anything_query', with: 'question'
        # find('anything_query').set('question')
        # save_and_open_page
        click_on 'Search'
      # end
      # save_and_open_page
      questions.each do |question|
        expect(page).to have_content question.title
      end
    end
  end
end