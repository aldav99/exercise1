require 'rails_helper'

feature 'Author can delete answer', %q{
  Only author can delete answer
 } do

  given(:user) { create(:user) }
  before(:each) do
    @question = create(:question, title: "TestTest")
    @author = create(:user)
    @answer = create(:answer, user: @author, question: @question, body: 'Test answer')
  end

  scenario "Author can delete answer" do
    sign_in(@author)

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

