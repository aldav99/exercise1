require 'rails_helper'

feature 'Author can delete question', %q{
  Only author can delete question
 } do

  given(:user) { create(:user) }

  scenario "Author can delete question" do
    sign_in(user)
    create_question

    expect(page).to have_content 'Test question'

    click_on 'Delete question'

    expect(page).to have_no_content 'Test question'

    expect(current_path).to eq root_path
  end

  scenario 'Another user cannot delete question' do
    sign_in(user)
    create_question
    click_on 'Log out'

    sign_up_with 'email@yandex.ru', 'password', 'password'
    
    expect(page).to have_no_content 'Delete question'
  end

  scenario 'Unloged user cannot delete question' do
    sign_in(user)
    create_question
    click_on 'Log out'
    visit root_path
    
    expect(page).to have_no_content 'Delete question'
  end
end