require 'rails_helper'

feature 'Author can delete answer', %q{
  Only author can delete answer
 } do

  given(:user) { create(:user) }

  scenario "Author can delete answer" do
    sign_in(user)
    create_question_and_answer

    click_on 'Show answer'
    click_on 'Delete answer'

    expect(page).to have_content 'The answer is deleted!!!'
  end

  scenario 'Another user cannot delete answer' do
    sign_in(user)
    create_question_and_answer
    click_on 'Log out'

    sign_up_with 'email@yandex.ru', 'password', 'password'

    click_on 'Show answer'
    click_on 'Delete answer'

    expect(page).to have_content "You aren't author"
  end
end