# frozen_string_literal: true

require 'rails_helper'

def add_user_to_db
  User.create(username: 'test_user', email: 'email', password: 'pswd')
end

describe User, type: :model do
  after(:all) { User.delete_all }
  it 'validates a normal user' do
    User.create(username: 'user', email: 'doesn\'t@matter', password: 'pswd')
  end

  it 'does not validate a user with mismatching confirmation' do
    user = User.new(username: 'test_user', email: 'email', password: 'pswd', password_confirmation: 'dwsp')
    expect(user).not_to be_valid
  end

  it 'does not validate non-unique username or email' do
    add_user_to_db
    match_name = User.new(username: 'test_user', email: 'new_test@email', password: 'pswd')
    match_email = User.new(username: 'new_test_user', email: 'email', password: 'pswd')
    expect(match_name).not_to be_valid
    expect(match_email).not_to be_valid
  end
end
