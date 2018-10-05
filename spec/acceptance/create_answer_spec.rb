require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from community
  As an authenticated user
} do

  given(:user) { create(:user_with_questions) }

  scenario 'Authenticated user create the answer' do
    sign_in(user)

    click_on 'questionquestion1'
    fill_in 'Body', with: 'text text'
    click_on 'Create'

    expect(page).to have_content 'text text'
  end

  scenario "Validation's error" do
    sign_in(user)

    click_on 'questionquestion1'

    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content "NOT"
  end

  scenario 'Non-authenticated user ties to create question' do
    @question = create(:question)
    visit questions_path
    click_on 'questionquestion1'

    expect(page).to have_no_content 'Create'
  end

end