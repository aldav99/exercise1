module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up_with(email, password, password_confirmation)
    visit new_user_session_path
    click_on 'Sign up'

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password_confirmation

    click_button 'Sign up'
  end
end
