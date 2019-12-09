require 'test_helper'

class V2SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get v2_search_search_url
    assert_response :success
  end

end
