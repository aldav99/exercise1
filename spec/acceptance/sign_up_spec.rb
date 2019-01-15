require_relative 'acceptance_helper'

feature 'User signs up' do
  scenario 'with valid email and password' do
    sign_up_with 'email@yandex.ru', 'password', 'password'

    expect(page).to have_content('You have signed up successfully.')
    expect(current_path).to eq root_path
  end

  scenario 'with invalid (<6 symbol) password' do
    sign_up_with 'email@yandex.ru', 'pass', 'password'

    expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    expect(current_path).to eq user_registration_path
  end

  scenario 'with invalid ( >128 symbol) password' do
    password = 'p'*129
    sign_up_with 'email@yandex.ru', password, password

    expect(page).to have_content 'Password is too long'
    expect(current_path).to eq user_registration_path
  end

  scenario 'with invalid password confirmation' do
    sign_up_with 'email@yandex.ru', 'password', 'pass'
    
    expect(page).to have_content "Password confirmation doesn't match"
    expect(current_path).to eq user_registration_path
  end

  scenario 'with blank password' do
    sign_up_with 'email@yandex.ru', '', ''

    expect(page).to have_content "Password can't be blank"
    expect(current_path).to eq user_registration_path
  end


  scenario 'with invalid email' do
    sign_up_with 'emailyandex.ru', 'password', 'password'

    expect(page).to have_content 'Email is invalid'
    expect(current_path).to eq user_registration_path
  end

  scenario 'can sign in user with Vkontakte account' do
    visit '/'
    
    click_on 'Log in'

    expect(page).to have_content('Sign in with Vkontakte')
    click_on 'Sign in with Vkontakte'
    expect(page).to have_content('Successfully authenticated from Vkontakte account')
    expect(page).to have_content("Log out")
  end

  scenario 'can sign in user with GitHub account with proper email' do
    visit '/'
    
    click_on 'Log in'

    expect(page).to have_content('Sign in with GitHub')
    
    click_on 'Sign in with GitHub'
    
    expect(page).to have_content('Promt your Email')

    fill_in 'auth[info][email]', with: 'testtest@test.com'
    click_on 'Submit'

    open_email('testtest@test.com')
    current_email.click_link 'Confirm my account'
    
    expect(page).to have_content 'Your email address has been successfully confirmed'
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account'
    expect(page).to have_content("Log out")
  end
end

