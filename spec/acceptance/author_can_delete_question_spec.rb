require 'rails_helper'

feature 'Author can delete question', %q{
  Only author can delete question
 } do

  given(:user) { create(:user) }

  scenario "Author can delete question" do
    sign_in(user)
    create_question_and_answer

    click_on 'Delete question'

    expect(page).to have_content 'The question is deleted!!!'
    expect(current_path).to eq root_path
  end

  # scenario "Registered user try to sign OUT" do
  #   sign_in(user)

  #   click_on 'Log out'
    
  #   expect(page).to have_content 'Signed out successfully.'
  # end

  scenario 'Another user cannot delete question' do
    sign_in(user)
    create_question_and_answer
    click_on 'Log out'

    sign_up_with 'email@yandex.ru', 'password', 'password'
    click_on 'Delete question'
    
    expect(page).to have_content "You aren't author"
    expect(current_path).to eq root_path
  end
end