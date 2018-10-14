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
end

