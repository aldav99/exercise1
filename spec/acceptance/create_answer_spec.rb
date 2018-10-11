require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from community
  As an authenticated user
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user, title: "TestTestTest") }

  scenario 'Authenticated user create the answer', js: true do
    sign_in(user)

    click_on 'TestTestTest'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'text text'
  end

  scenario "Validation's error", js: true do
    sign_in(user)

    click_on 'TestTestTest'

    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user ties to create question' do
    @question = create(:question, title: "TestTestTestNon" )
    visit questions_path
    click_on 'TestTestTestNon'

    expect(page).to have_no_content 'Create'
  end

end