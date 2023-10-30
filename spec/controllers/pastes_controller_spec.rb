# frozen_string_literal: true

require 'rails_helper'

describe PastesController, type: :controller do
  render_views
  it 'should get new paste form' do
    get :new
    expect(response.status).to eq 200
    expect(response.body).to include('New paste')
  end
end
