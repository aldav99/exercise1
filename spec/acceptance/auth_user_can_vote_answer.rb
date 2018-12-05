require_relative 'acceptance_helper'

feature 'User is able to vote, but author NOT', %q{
  In order to illustrate my answer
  As an NOT answer's author is able to vote
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:author_answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "is able to vote", js: true do

    within '.answer_vote_select-1' do
      expect(page).to have_link 'Like'
      expect(page).to have_link 'DisLike'
      expect(page).to have_link 'Reset'
    end
  end

  scenario "is able to LIKE", js: true do
    within '.answer_vote_select-1' do
      click_link('Like')
    end

    within '.answer_vote-1' do
      expect(page).to have_content '1'
    end
  end

  scenario "do not vote 2 times", js: true do
    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    within '.vote_answers_errors-1' do
      expect(page).to have_content 'has already been taken'
    end
  end

  scenario "RESET is valid", js: true do
    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    within '.answer_vote_select-1' do
      click_link('Reset')
    end

    within '.answer_vote-1' do
      expect(page).to have_content '0'
    end

    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    within '.answer_vote-1' do
      expect(page).to have_content '-1'
    end
  end

  scenario "Author is not able to vote", js: true do
    within '.answer_vote_select-2' do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'DisLike'
      expect(page).to_not have_link 'Reset'
    end
  end

  scenario "Another user is able to vote same answer", js: true do
    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    click_link('Log out')
    sign_in(another_user)
    visit question_path(question)

    within '.answer_vote-1' do
      expect(page).to have_content '-1'
    end

    within '.answer_vote_select-1' do
      click_link('DisLike')
    end

    within '.answer_vote-1' do
      expect(page).to have_content '-2'
    end
  end
end
