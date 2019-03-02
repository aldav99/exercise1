require_relative 'acceptance_helper'
require 'rake'
require 'thinking_sphinx/tasks'

feature 'Can do search', %q{
  I want to be able to search
} do

  let!(:user) { create(:user, email: 'test@email.com') }
  let!(:question) { create(:question, body: 'test question') }
  let!(:answer) { create(:answer, question: question, body: 'test answer') }
  let!(:comment) { create(:comment, user: user, commentable: question, body: 'test comment') }

  scenario "User find question", js: true do
    ThinkingSphinx::Test.run do
      visit root_path
      select "question", from: 'anything_search_type'
      fill_in 'anything_query', with: 'test question'
      click_on 'Search'

      expect(page).to have_content question.body

      expect(current_path).to eq search_index_path
    end
  end

  scenario "User find answer", js: true do
    ThinkingSphinx::Test.run do
      visit root_path
      select "answer", from: 'anything_search_type'
      fill_in 'anything_query', with: 'test answer'
      click_on 'Search'

      expect(page).to have_content answer.body

      expect(current_path).to eq search_index_path
    end
  end

  scenario "User find comment", js: true do
    ThinkingSphinx::Test.run do
      visit root_path
      select "comment", from: 'anything_search_type'
      fill_in 'anything_query', with: 'test comment'
      click_on 'Search'

      expect(page).to have_content comment.body

      expect(current_path).to eq search_index_path
    end
  end

  scenario "User find user", js: true do
    ThinkingSphinx::Test.run do
      visit root_path
      select "user", from: 'anything_search_type'
      fill_in 'anything_query', with: 'test@email.com'
      click_on 'Search'

      expect(page).to have_content user.email

      expect(current_path).to eq search_index_path
    end
  end

  scenario "User find ALL", js: true do
    ThinkingSphinx::Test.run do
      visit root_path
      select "all", from: 'anything_search_type'
      fill_in 'anything_query', with: 'test'
      click_on 'Search'

      expect(page).to have_content user.email
      expect(page).to have_content comment.body
      expect(page).to have_content answer.body
      expect(page).to have_content question.body

      expect(current_path).to eq search_index_path
    end
  end
end