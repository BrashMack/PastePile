# frozen_string_literal: true

require 'application_system_test_case'

class PastesTest < ApplicationSystemTestCase
  setup do
    @paste = pastes(:one)
  end

  test 'visiting the index' do
    visit pastes_url
    assert_selector 'h1', text: 'Pastes'
  end

  test 'creating a Paste' do
    visit pastes_url
    click_on 'New Paste'

    fill_in 'Content', with: @paste.content
    fill_in 'Language', with: @paste.language
    fill_in 'Name', with: @paste.name
    fill_in 'Owner', with: @paste.owner
    check 'Private' if @paste.private
    click_on 'Create Paste'

    assert_text 'Paste was successfully created'
    click_on 'Back'
  end

  test 'updating a Paste' do
    visit pastes_url
    click_on 'Edit', match: :first

    fill_in 'Content', with: @paste.content
    fill_in 'Language', with: @paste.language
    fill_in 'Name', with: @paste.name
    fill_in 'Owner', with: @paste.owner
    check 'Private' if @paste.private
    click_on 'Update Paste'

    assert_text 'Paste was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Paste' do
    visit pastes_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Paste was successfully destroyed'
  end
end
