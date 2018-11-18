require_relative 'acceptance_helper'

feature 'Delete files from answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to deattach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:attachment) { create(:attachment, attachmentable: answer) }
  given(:attachments) {create_list(:attachment, 2, attachmentable: answer) }
  given(:not_author) { create(:user) }

  scenario 'User delete file from answer', js: true do
    attachment
    sign_in(user)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    
    click_link 'Delete file'
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User delete many files from answer', js: true do
    attachments
    sign_in(user)
    visit question_path(question)

    find('.answers tbody').first(:link, "Delete file").click
    click_link 'Delete file'

    expect(page).to_not have_link attachments.first.file.filename, href: attachments.first.file.url
    expect(page).to_not have_link attachments.last.file.filename, href: attachments.second.file.url
  end

  scenario 'Another user can not delete file from question', js: true do
    sign_in(not_author)
    attachment
    visit question_path(question)

    expect(page).to_not have_link 'Delete file'
  end
end