require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to answer', js: true do
    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'
    click_on 'Edit'
    # attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    # inputs = all('input[type="file"]')
    # attach_file inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    page.attach_file("answer[attachments_attributes][0][file]", Rails.root + 'spec/spec_helper.rb')
    # wait_for_ajax
    click_on 'Save'

    # visit question_path(question)

    # save_and_open_page

    # within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    # end
  end
end