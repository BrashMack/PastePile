# frozen_string_literal: true

require 'rails_helper'

USERNAME = 'test_user'
EMAIL = 'test@example.org'
PASSWORD = 'password'

def create_user(username = USERNAME, email = EMAIL, password = PASSWORD)
  User.create(username: username, email: email, password: password)
end

def signin(username = USERNAME, password = PASSWORD)
  visit '/signin'
  fill_in 'Username', with: username
  fill_in 'Password', with: password
  click_on :commit
end

describe 'Account system', type: :feature do
  it 'allows to register a user', js: true do
    visit '/signup'
    fill_in 'Username', with: USERNAME
    fill_in 'Email', with: EMAIL
    fill_in 'Password', with: PASSWORD
    fill_in 'Confirm password', with: PASSWORD
    click_on 'Submit'
    expect(User.find_by(username: 'test_user')).not_to be_nil
    expect(page.body).to include 'test_user'
  end

  it 'does not allow to sign in as nonexistent user', js: true do
    signin
    expect(page.body).to include 'Invalid credentials'
  end

  it 'allows user to sign in', js: true do
    create_user
    signin
    expect(page.body).to include 'test_user'
  end
end
