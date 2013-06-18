require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get verify" do
    get :verify
    assert_response :success
  end

end
