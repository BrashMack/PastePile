# frozen_string_literal: true

class Paste < ApplicationRecord
  before_save :set_default_values
  belongs_to :user, optional: true
  validates_presence_of :content
  validates_inclusion_of :private, in: [false], if: :anonymous?, message: 'pastes can only be created once logged in'

  def set_default_values
    self.language = 'plaintext' if language.blank?
  end

  def anonymous?
    user.nil?
  end
end
