require 'rails_helper'

feature 'Author can delete answer', %q{
  Only author can delete answer
 } do

  given(:user) { create(:user) }

  scenario "Author can delete answer" do
    sign_in(user)
    create_question_and_answer

    expect(page).to have_content 'Delete answer'

    click_on 'Delete answer'

    expect(page).to have_no_content 'Delete answer'
  end

  scenario 'Another user cannot delete answer' do
    sign_in(user)
    create_question_and_answer
    click_on 'Back'
    click_on 'Log out'

    sign_up_with 'email@yandex.ru', 'password', 'password'

    click_on 'Test question'

    expect(page).to have_no_content 'Delete answer'
  end
  
  scenario 'Unloged user cannot delete answer' do
    sign_in(user)
    create_question_and_answer
    click_on 'Back'
    click_on 'Log out'

    visit root_path

    click_on 'Test question'

    expect(page).to have_no_content 'Delete answer'
  end
end

