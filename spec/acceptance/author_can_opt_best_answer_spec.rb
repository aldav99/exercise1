require_relative 'acceptance_helper'

feature 'Author can opt best answer', %q{
  Only author can opt best answer
 } do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:author) { create(:user) }
  given!(:answer) { create(:answer, user: author, question: question) }
  # given!(:answer) { create(:answer, user: author, question: question, body: 'Test answer') }

  scenario "Question's Author can opt best answer" do
    sign_in(author)

    visit question_path(question)

    expect(page).to have_link 'Best answer?'

    click_on 'Best answer?'
    expect(page).to have_no_link 'Best answer?'
  end

  scenario "Question's Author can opt other best answer.Best answer is only ONE" do
   
    best_answer = create(:answer, user: author, question: question, best: true)
  
    sign_in(author)

    visit question_path(question)
    expect(page).to have_css("p#true", count: 1)
    expect(page).to have_link 'Best answer?'
    click_on 'Best answer?'
    expect(page).to have_css("p#true", count: 1)
    expect(page).to have_link 'Best answer?'
  end

  scenario "Best answer is first list's element" do
    best_answer = create(:answer, user: author, question: question, best: true)
    sign_in(author)

    visit question_path(question)
    expect(page).to have_css(".answers p:first-child#true")
  end

  scenario 'Another user cannot opt best answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_no_link 'Best answer?'
  end
  
  scenario 'Unloged user cannot opt best answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Best answer?'
  end
end