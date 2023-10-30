# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  render_views
  it 'should get sign in form' do
    get :new
    expect(response.status).to eq 200
    expect(response.body).to include('Sign in')
  end
end
