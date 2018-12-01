require_relative 'acceptance_helper'

feature 'User is able to vote, but author NOT', %q{
  In order to illustrate my question
  As an NOT question's author is able to vote
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:author_question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "is able to vote", js: true do
    
    within '.question_vote_select' do
      expect(page).to have_link 'Like'
      expect(page).to have_link 'DisLike'
      expect(page).to have_link 'Reset'
    end

    within '.question_vote_select' do
      click_link('Like')
    end

    within '.question_vote' do
      expect(page).to have_content '1'
    end

    within '.question_vote_select' do
      click_link('DisLike')
    end

    expect(page).to have_content 'has already been taken'

    within '.question_vote_select' do
      click_link('Reset')
    end

    within '.question_vote' do
      expect(page).to have_content '0'
    end

    within '.question_vote_select' do
      click_link('DisLike')
    end

    within '.question_vote' do
      expect(page).to have_content '-1'
    end

    visit question_path(author_question)

    within '.question_vote_select' do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'DisLike'
      expect(page).to_not have_link 'Reset'
    end


    click_link('Log out')
    sign_in(another_user)
    visit question_path(question)

    within '.question_vote' do
      expect(page).to have_content '-1'
    end

    within '.question_vote_select' do
      click_link('DisLike')
    end

    within '.question_vote' do
      expect(page).to have_content '-2'
    end

  end
end
