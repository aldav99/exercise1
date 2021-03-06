require_relative 'acceptance_helper'

feature 'Author can delete question', %q{
  Only author can delete question
 } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user, title: 'Test question') }
  given!(:another_user){create(:user)}

  scenario "Author can delete question" do
    sign_in(user)

    expect(page).to have_content 'Test question'

    click_on 'Delete question'

    expect(page).to have_no_content 'Test question'
    expect(current_path).to eq root_path
  end

  scenario 'Another user cannot delete question' do
    sign_in(another_user)

    expect(page).to have_content 'Test question'
    expect(page).to have_no_link 'Delete question'
  end

  scenario 'Unloged user cannot delete question' do
    visit root_path
    
    expect(page).to have_content 'Test question'
    expect(page).to have_no_link 'Delete question'
  end
end