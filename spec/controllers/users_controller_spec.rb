# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  render_views
  it 'should get registration form' do
    get :new
    expect(response.status).to eq 200
    expect(response.body).to include('Sign up')
  end
end
