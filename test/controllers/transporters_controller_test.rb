require 'test_helper'

class TransportersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transporter = transporters(:one)
  end

  test 'should get index' do
    get transporters_url, as: :json
    assert_response :success
  end

  test 'should create transporter' do
    assert_difference('Transporter.count') do
      post transporters_url, params: { transporter: {} }, as: :json
    end

    assert_response 201
  end

  test 'should show transporter' do
    get transporter_url(@transporter), as: :json
    assert_response :success
  end

  test 'should update transporter' do
    patch transporter_url(@transporter), params: { transporter: {} }, as: :json
    assert_response 200
  end

  test 'should destroy transporter' do
    assert_difference('Transporter.count', -1) do
      delete transporter_url(@transporter), as: :json
    end

    assert_response 204
  end
end
