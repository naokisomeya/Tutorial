require 'test_helper'

class FoosControllerTest < ActionDispatch::IntegrationTest
  test "should get bar" do
    get foos_bar_url
    assert_response :success
  end

  test "should get baz" do
    get foos_baz_url
    assert_response :success
  end

end
