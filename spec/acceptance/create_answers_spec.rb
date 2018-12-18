require_relative 'acceptance_helper'

feature 'User answer', %q{
  In order to exchange my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  context "mulitple sessions" do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
 
      Capybara.using_session('guest') do
        sign_in(guest)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'My answer'
        within '.new_answer' do 
          click_on 'Create'
        end

        within '.answers' do
          expect(page).to have_content 'My answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My answer'
      end
    end
  end  
end