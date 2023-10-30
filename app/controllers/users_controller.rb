# frozen_string_literal: true

# Users Controller controls user data
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :check_if_editing_admin, only: %i[edit update destroy]
  before_action :check_admin_permission, only: :index
  before_action :check_admin_or_self_permission, except: %i[index new create]
  skip_before_action :authenticate, only: %i[new create]
  # GET /users
  def index
    query = {
      username: params[:username].presence
    }.compact
    @users = search_query(query, params[:page].to_i || 0)
  end

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html do
          flash[:notice] = t('forms.messages.registration_successful')
          redirect_to_index
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if update_user(user_params) # this contraption means 'accept updates without password'
        format.html do
          flash[:notice] = t('forms.messages.user_was_successfully_updated')
          redirect_to @user
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      flash[:notice] = t('forms.messages.user_was_successfully_destroyed')
      format.html { redirect_to users_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def check_if_editing_admin
    refuse_with_method_not_allowed if @user.admin && current_user.id != @user.id && !current_user.superuser
  end

  def search_query(query, page)
    [if query.any?
       User.where(query).limit(PER_PAGE).offset(PER_PAGE * page)
     else
       User.all.limit(PER_PAGE).offset(PER_PAGE * page)
     end].flatten.compact
  end

  # Only allow a list of trusted parameters through.
  def user_params
    if current_user&.superuser
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin, :superuser)
    else
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end

  def redirect_to_index
    if session[:current_user_id]
      redirect_to users_path
    else
      sign_in @user
    end
  end

  def check_admin_permission
    refuse_with_method_not_allowed unless current_user.admin
  end

  def check_admin_or_self_permission
    refuse_with_method_not_allowed unless current_user.admin || current_user.id == params[:id].to_i
  end

  def update_user(submitted_user_params)
    if current_user&.admin && submitted_user_params[:password].blank?
      @user.update_columns(user_params.to_unsafe_h.except(:password))
    else
      @user.update(user_params)
    end
  end
end
