require 'test_helper'

class ContactUsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact_u = contact_us(:one)
  end

  test "should get index" do
    get contactUs_url, as: :json
    assert_response :success
  end

  test "should create contact_u" do
    assert_difference('ContactU.count') do
      post contactUs_url, params: { contact_u: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show contact_u" do
    get contactU_url(@contact_u), as: :json
    assert_response :success
  end

  test "should update contact_u" do
    patch contactU_url(@contact_u), params: { contact_u: {  } }, as: :json
    assert_response 200
  end

  test "should destroy contact_u" do
    assert_difference('ContactU.count', -1) do
      delete contactU_url(@contact_u), as: :json
    end

    assert_response 204
  end
end
