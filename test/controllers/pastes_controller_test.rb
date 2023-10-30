# frozen_string_literal: true

require 'test_helper'

class PastesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @paste = pastes(:one)
  end

  test 'should get index' do
    get pastes_url
    assert_response :success
  end

  test 'should get new' do
    get new_paste_url
    assert_response :success
  end

  test 'should create paste' do
    assert_difference('Paste.count') do
      post pastes_url,
           params: { paste: { content: @paste.content, language: @paste.language, name: @paste.name, owner: @paste.owner,
                              private: @paste.private } }
    end

    assert_redirected_to paste_url(Paste.last)
  end

  test 'should show paste' do
    get paste_url(@paste)
    assert_response :success
  end

  test 'should get edit' do
    get edit_paste_url(@paste)
    assert_response :success
  end

  test 'should update paste' do
    patch paste_url(@paste),
          params: { paste: { content: @paste.content, language: @paste.language, name: @paste.name, owner: @paste.owner,
                             private: @paste.private } }
    assert_redirected_to paste_url(@paste)
  end

  test 'should destroy paste' do
    assert_difference('Paste.count', -1) do
      delete paste_url(@paste)
    end

    assert_redirected_to pastes_url
  end
end
