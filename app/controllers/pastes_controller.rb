# frozen_string_literal: true

LANGUAGES = JSON.parse(File.read("#{Rails.root}/public/languages.json"))

# Pastes controller
class PastesController < ApplicationController
  before_action :set_paste, only: %i[show edit update destroy]
  before_action :check_modify_access, only: %i[edit update destroy]
  before_action :check_view_access, only: %i[show]
  skip_before_action :authenticate, only: %i[new create show]

  # GET /pastes
  def index
    @pastes = search_query({
      name: params[:name].presence,
      user_id: @current_user&.admin ? find_user_id(params[:username]) : @current_user
    }.compact, params[:page].to_i || 0)
  end

  # GET /pastes/1
  def show; end

  # GET /pastes/new
  def new
    @paste = Paste.new
  end

  # GET /pastes/1/edit
  def edit; end

  # POST /pastes
  def create
    @paste = Paste.new(paste_params)
    @paste.user = current_user
    respond_to do |format|
      if @paste.save
        format.html { redirect_to @paste, notice: t('forms.messages.paste_was_successfully_created') }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pastes/1
  def update
    @flag = true
    respond_to do |format|
      if @paste.update(paste_params)
        format.html { redirect_to @paste, notice: t('forms.messages.paste_was_successfully_updated') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pastes/1
  def destroy
    @paste.destroy
    respond_to do |format|
      format.html { redirect_to pastes_url, notice: t('forms.messages.paste_was_successfully_destroyed') }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  def set_paste
    @paste = Paste.find(params[:id])
  end

  def check_view_access
    refuse_with_method_not_allowed unless !@paste.private || current_user&.admin || @paste.user == current_user
  end

  def check_modify_access
    refuse_with_method_not_allowed unless current_user&.admin || @paste.user == current_user
  end

  def find_user_id(username)
    nil unless username.presence
    User.find_by(username: username)&.id
  end

  def search_query(query, page)
    if query.key?(:user_id) && !query[:user_id]
      []
    else
      [if query.any?
         Paste.where(query).limit(PER_PAGE).offset(PER_PAGE * page)
       else
         Paste.all.limit(PER_PAGE).offset(PER_PAGE * page)
       end].flatten.compact
    end
  end

  # Only allow a list of trusted parameters through.
  def paste_params
    params.require(:paste).permit(:name, :content, :language, :private)
  end
end
