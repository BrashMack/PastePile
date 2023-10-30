# frozen_string_literal: true

require 'test_helper'

class LuckyNumsControllerTest < ActionDispatch::IntegrationTest
  test 'should get input' do
    get lucky_nums_input_url
    assert_response :success
  end

  test 'should get output' do
    get lucky_nums_output_url
    assert_response :success
  end
end
