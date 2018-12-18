require_relative 'acceptance_helper'

feature 'Create comment to question', %q{
  I want to be able to add comment to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  # given(:answer) { create(:answer, question: question) }

  scenario 'Authenticated user create the comment', js: true  do
    sign_in(user)

    visit question_path question
    within '.comment' do 
      click_link 'Add comment'
      fill_in 'Your comment', with: 'My comment'
      click_on 'Create'
    end

    expect(page).to have_content 'My comment'
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path question
      end
 
      Capybara.using_session('guest') do
        visit question_path question
      end

      Capybara.using_session('user') do
        within '.comment' do 
          click_link 'Add comment'
          fill_in 'Your comment', with: 'My comment'
          click_on 'Create'
        end

        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My comment'
      end
    end
  end  
end