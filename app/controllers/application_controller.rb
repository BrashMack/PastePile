# frozen_string_literal: true

PER_PAGE = 20

# This is the base controller for the app
class ApplicationController < ActionController::Base
  before_action :preserve_params, only: :index
  before_action :count_pages, only: :index
  before_action :authenticate
  before_action :set_current_user
  around_action :select_locale

  def current_user
    User.find(session[:current_user_id])
  rescue StandardError
    nil
  end

  def set_current_user
    @current_user = current_user
  end

  private

  def authenticate
    redirect_to signin_path unless current_user
  end

  def sign_in(user)
    session[:current_user_id] = user.id
    redirect_to root_path
  end

  def refuse_with_method_not_allowed
    respond_to do |format|
      format.all { render html: File.read('public/405.html').html_safe, status: :method_not_allowed }
    end
  end

  def retrieve_locales
    request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/[a-z]{2}/)
  end

  def valid_locale
    retrieve_locales&.find { |locale| I18n.available_locales.include? locale.intern } || I18n.default_locale
  end

  def select_locale(&action)
    I18n.with_locale(valid_locale, &action)
  end

  def preserve_params
    @params = params
  end

  def count_pages
    @pages = (User.count / PER_PAGE) + 1
  end
end
