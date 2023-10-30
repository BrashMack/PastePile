# frozen_string_literal: true

require 'rails_helper'

describe 'Access control system', type: :feature do
  it 'allows a user to edit own account', js: true do
    create_user
    signin
    click_on 'My account'
    click_on 'Edit'
    fill_in 'Email', with: 'new_address@email.com'
    fill_in 'Password', with: PASSWORD
    click_on 'Submit'
    expect(page.body).to include('new_address@email.com')
  end

  it 'does not allow access to any account unless authenticated' do
    visit "/users/#{create_user.id}/"
    expect(page.body).not_to include(USERNAME)
  end

  it 'does not allow editing any account unless authenticated' do
    visit "/users/#{create_user.id}/edit"
    expect(page.body).not_to include(USERNAME)
  end

  it 'does not allow user to index accounts', js: true do
    Rails.application.load_seed
    create_user('another', 'another', 'pswd')
    signin('another', 'another')
    visit '/users/index'
    expect(page.body).not_to include('Users')
  end

  it 'does not allow user to access other accounts', js: true do
    Rails.application.load_seed
    create_user('another', 'another', 'pswd')
    signin('another', 'another')
    visit "/users/#{create_user.id}/"
    expect(page.body).not_to include(USERNAME)
  end

  it 'does not allow user to edit other accounts', js: true do
    Rails.application.load_seed
    create_user('another', 'another', 'pswd')
    signin('another', 'another')
    visit "/users/#{create_user.id}/edit"
    expect(page.body).not_to include(USERNAME)
  end

  it 'allows admin to edit accounts', js: true do
    Rails.application.load_seed
    create_user
    signin('root', 'root')
    visit "/users/#{User.find_by(username: USERNAME).id}/edit"
    fill_in 'Email', with: 'another@another.org'
    click_on 'Submit'
    expect(page.body).to include('another@another.org')
  end

  it 'allows superuser to make accounts admin', js: true do
    Rails.application.load_seed
    create_user
    signin('root', 'root')
    visit "/users/#{User.find_by(username: USERNAME).id}/edit"
    check 'Is admin'
    click_on 'Submit'
    expect(User.find_by(username: USERNAME).admin).to be true
  end

  it 'allows admin to index and search accounts' do
    Rails.application.load_seed
    create_user
    create_user('another', 'another', 'pswd')
    signin('root', 'root')
    visit '/users'
    expect(page.body).to include('Users')
    expect(page.body).to include('test_user')
    expect(page.body).to include('another')
    fill_in 'Username', with: 'another'
    click_on 'Search'
    expect(page.body).to include('another')
    expect(page.body).not_to include(USERNAME)
  end
end
