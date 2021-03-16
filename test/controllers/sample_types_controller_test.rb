require 'test_helper'

class SampleTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sample_type = sample_types(:one)
  end

  test "should get index" do
    get sample_types_url
    assert_response :success
  end

  test "should get new" do
    get new_sample_type_url
    assert_response :success
  end

  test "should create sample_type" do
    assert_difference('SampleType.count') do
      post sample_types_url, params: { sample_type: { name: @sample_type.name } }
    end

    assert_redirected_to sample_type_url(SampleType.last)
  end

  test "should show sample_type" do
    get sample_type_url(@sample_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_sample_type_url(@sample_type)
    assert_response :success
  end

  test "should update sample_type" do
    patch sample_type_url(@sample_type), params: { sample_type: { name: @sample_type.name } }
    assert_redirected_to sample_type_url(@sample_type)
  end

  test "should destroy sample_type" do
    assert_difference('SampleType.count', -1) do
      delete sample_type_url(@sample_type)
    end

    assert_redirected_to sample_types_url
  end
end
