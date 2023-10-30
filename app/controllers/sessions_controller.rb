# frozen_string_literal: true

# Session Controller. Controls sessions. Why
class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create]

  def new; end

  def invalid_credentials_error
    flash[:error] = t('forms.messages.invalid_credentials')
    redirect_to action: :new
  end

  def create
    user_data = params[:user]
    user = User.find_by(username: user_data[:username])
    if user&.authenticate(user_data[:password])
      sign_in user
    else
      invalid_credentials_error
    end
  end

  def destroy
    session.delete(:current_user_id)
    redirect_to root_path
  end
end
