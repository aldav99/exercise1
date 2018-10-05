require 'rails_helper'

feature 'View answers', %q{
  View answers' list
} do

  given(:user) { create(:user) }
  before {@question = create(:question_with_answers)}


  scenario 'Authenticated user is able to answers' do
    sign_in(user)

    click_on 'questionquestion1'

    expect(page).to have_content("answeranswer", count: 5)
  end
end