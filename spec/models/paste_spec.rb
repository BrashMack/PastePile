# frozen_string_literal: true

require 'rails_helper'

describe Paste, type: :model do
  it 'validates a normal paste' do
    expect(Paste.new(content: 'content')).to be_valid
  end

  it 'does not validate empty pastes' do
    expect(Paste.new).not_to be_valid
  end
end
