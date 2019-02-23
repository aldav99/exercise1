require_relative 'acceptance_helper'

feature 'subscribe question', %q{
  In order to receive answers by mail
  As autorized user
  I want to be able to subscribe for questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:author_question) { create(:question, user: user) }

  given!(:subscribed_question) { create(:question) }
  given!(:subscriber) { create(:subscriber, user: user, question: subscribed_question) }

  scenario 'Unauthenticated user cant see subscribe buttons', js:true do
    visit question_path(question)
    expect(page).to_not have_link "Subscribe"
    expect(page).to_not have_link "Unsubscribe"
  end

  scenario 'Authenticated user can subscribe unsubscribed question', js:true do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_link "Subscribe"
    expect(page).to_not have_link "Unsubscribe"
    click_on "Subscribe"
    expect(page).to_not have_link "Subscribe"
    expect(page).to have_link "Unsubscribe"
  end

  scenario 'Authenticated user can unsubscribe subscribed question', js:true do
    sign_in(user)
    visit question_path(subscribed_question)
    expect(page).to_not have_link "Subscribe"
    expect(page).to have_link "Unsubscribe"
    click_on "Unsubscribe"
    expect(page).to_not have_link "Unsubscribe"
    expect(page).to have_link "Subscribe"
  end


  scenario 'Author can unsubscribe', js:true do
    sign_in(user)
    visit question_path(author_question)
    expect(page).to have_link "Unsubscribe"
  end
end