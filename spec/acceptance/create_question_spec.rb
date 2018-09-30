require 'rails_helper'

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

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user view the questions list' do
    sign_in(user)

    visit questions_path
  end

  scenario 'Authenticated user create the answer' do
    sign_in(user)


    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'
    
    fill_in 'Body', with: 'Test answer'
    fill_in 'Correct', with: true
    click_on 'Create'

    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Authenticated user is able to view questions and answers' do
    sign_in(user)


    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    fill_in 'Body', with: 'Test answer'
    fill_in 'Correct', with: true
    click_on 'Create'

    visit questions_path
    click_on 'Show answer'

    expect(page).to have_content 'Your question and answers'
  end
end