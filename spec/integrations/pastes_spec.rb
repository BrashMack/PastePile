# frozen_string_literal: true

require 'rails_helper'

def create_paste(name = 'test_paste', content = 'content')
  visit '/'
  fill_in 'Name', with: name
  fill_in 'Content', with: content
  click_on 'Submit'
  page.current_path
end

describe 'Paste system', type: :feature do
  it 'allows to create an anonymous paste' do
    visit '/'
    fill_in 'Name', with: 'test_paste'
    fill_in 'Content', with: 'content'
    click_on 'Submit'
    expect(Paste.count).to eq 1
  end

  it 'allows to create a private paste with an account and doesn\'t allow to see it anonymously' do
    create_user
    signin
    visit '/'
    fill_in 'Name', with: 'test_paste'
    fill_in 'Content', with: 'secret'
    check 'Is private'
    click_on 'Submit'
    private_path = page.current_path
    click_on 'Sign out'
    visit private_path
    expect(page.body).not_to include 'secret'
  end

  it 'allows to edit own paste' do
    create_user
    signin
    create_paste
    click_on 'Edit'
    fill_in 'Content', with: 'New content'
    click_on 'Submit'
    expect(page.body).to include 'New content'
  end

  it 'allows admin to edit pastes' do
    Rails.application.load_seed
    create_user
    signin
    paste_path = create_paste
    p paste_path
    signin('root', 'root')
    visit paste_path
    click_on 'Edit'
    fill_in 'Content', with: 'New content'
    click_on 'Submit'
    expect(page.body).to include 'New content'
  end

  it 'does not allow to edit pastes unless authenticated' do
    create_user
    signin
    create_paste
    paste_path = current_path
    click_on 'Sign out'
    visit "#{paste_path}/edit"
    expect(page.body).not_to include 'Content'
  end

  it 'does not allow to edit pastes unless admin or owner' do
    create_user
    create_user('another', 'another', 'pswd')
    signin
    create_paste
    paste_path = current_path
    click_on 'Sign out'
    signin('another', 'pswd')
    visit "#{paste_path}/edit"
    expect(page.body).not_to include 'Content'
  end

  it 'allows to index and search own pastes' do
    create_user
    signin
    create_paste
    create_paste 'another', 'text'
    visit '/pastes'
    expect(page.body).to include('Pastes')
    expect(page.body).to include('test_paste')
    expect(page.body).to include('another')
    fill_in 'Name', with: 'test_paste'
    click_on 'Search'
    expect(page.body).to include('test_paste')
    expect(page.body).not_to include('another')
  end

  it 'allows admin index and search all pastes' do
    Rails.application.load_seed
    create_user
    signin
    create_paste
    create_paste 'another', 'text'
    click_on 'Sign out'
    signin 'root', 'root'
    visit '/pastes'
    expect(page.body).to include('Pastes')
    expect(page.body).to include('test_paste')
    expect(page.body).to include('another')
    fill_in 'Name', with: 'test_paste'
    click_on 'Search'
    expect(page.body).to include('test_paste')
    expect(page.body).not_to include('another')
  end
end
