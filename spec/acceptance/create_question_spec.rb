require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user create the question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'text text'
    expect(page).to have_content 'Test question'
  end

  scenario "Validation's error" do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "can't be blank"
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path

    expect(page).to have_no_content 'Ask question'
  end

  context "mulitple sessions" do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
 
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text'
        click_on 'Create'

        expect(page).to have_content 'text text'
        expect(page).to have_content 'Test question'
        save_and_open_page
      end

      Capybara.using_session('guest') do
        save_and_open_page
        expect(page).to have_content 'Test question'
      end
    end
  end  
end