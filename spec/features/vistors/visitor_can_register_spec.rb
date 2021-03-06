require 'rails_helper'

describe 'as a visitor', :vcr, :js do
  it 'will register a new account' do
    visit root_path

    click_on 'Sign In'

    expect(current_path).to eq(login_path)

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: 'jimbob@aol.com'
    fill_in 'user[first_name]', with: 'Jim'
    fill_in 'user[last_name]', with: 'Bob'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'

    click_on'Create Account'

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content('jimbob@aol.com')
    expect(page).to have_content('Jim')
    expect(page).to have_content('Bob')
    expect(page).to_not have_content('Sign In')
  end

  it 'will not allow a user to register with an existing email' do
    user = create(:user, email: 'jimbob@aol.com')

    visit login_path

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: 'jimbob@aol.com'
    fill_in 'user[first_name]', with: 'Jim'
    fill_in 'user[last_name]', with: 'Bob'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'

    click_on'Create Account'

    expect(page).to have_content('Username already exists')
  end

  it 'sends an email confirmation token after registration' do
    visit root_path

    click_on 'Sign In'

    expect(current_path).to eq(login_path)

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: 'jimbob@aol.com'
    fill_in 'user[first_name]', with: 'Jim'
    fill_in 'user[last_name]', with: 'Bob'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'

    click_on'Create Account'

    user = User.last

    expect(user.email_confirmed).to eq(false)
    expect(user.confirm_token).to be_a(String)

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content('This account has not yet been activated. Please check your email.')
  end

  it 'allows me to confirm my account' do
    user = create(:user, confirm_token: '123445689234')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit "/confirm?token=#{user.confirm_token}"

    expect(current_path).to eq(dashboard_path)
    expect(user.email_confirmed).to eq(true)
    expect(page).to have_content('Thank you! Your account is now activated.')
  end

  it 'will not confirm an account with an invalid token' do
    user = create(:user, confirm_token: '123445689234')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/confirm?token=12u2o3u4o2u348u2304598298'

    expect(current_path).to eq(root_path)
    expect(user.email_confirmed).to eq(false)
    expect(page).to have_content('Error! That token is not valid.')
  end
end
