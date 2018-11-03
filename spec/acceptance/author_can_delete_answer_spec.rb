require_relative 'acceptance_helper'

feature 'Author can delete answer', %q{
  Only author can delete answer
 } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, title: "TestTest") }
  given!(:author) { create(:user) }
  given!(:answer) { create(:answer, user: author, question: question, body: 'Test answer') }

  scenario "Author can delete answer", js: true do
    sign_in(author)

    click_on 'TestTest'
    expect(page).to have_content 'Test answer'

    click_on 'Delete answer'
    expect(page).to have_no_content 'Test answer'
  end

  scenario 'Another user cannot delete answer' do
    sign_in(user)

    click_on 'TestTest'

    expect(page).to have_no_link 'Delete answer'
  end
  
  scenario 'Unloged user cannot delete answer' do
    visit root_path

    click_on 'TestTest'

    expect(page).to have_no_link 'Delete answer'
  end
end

