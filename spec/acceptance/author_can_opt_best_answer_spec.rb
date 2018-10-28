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
    @answer1 = create(:answer, question: question, body: 'answer1')
      
    sign_in(author)

    visit question_path(question)
    
    expect(page).to_not have_css(".answers p:first-child#true")

    find(:xpath, "(//a[text()='Best answer?'])[2]").click

    expect(page).to have_css(".answers p:first-child#true", text: @answer1.body)
    expect(page).to have_css(".answers p#true", count: 1)
  end

  scenario "Opting best answer not change best answer another's question" do
    best_answer = create(:answer, question: question, best: true)
    another_question = create(:question, user: author)
    another_answer = create(:answer, question: another_question)

    sign_in(author)
    visit question_path(another_question)
    click_on 'Best answer?'
    expect(page).to have_css(".answers p:first-child#true", text: another_answer.body)

    visit question_path(question)
    expect(page).to have_css(".answers p:first-child#true", text: best_answer.body)
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