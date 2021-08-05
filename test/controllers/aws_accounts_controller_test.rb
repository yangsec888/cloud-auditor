require 'test_helper'

class AwsAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aws_account = aws_accounts(:one)
  end

  test "should get index" do
    get aws_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_aws_account_url
    assert_response :success
  end

  test "should create aws_account" do
    assert_difference('AwsAccount.count') do
      post aws_accounts_url, params: { aws_account: { audit_time: @aws_account.audit_time, bus_unit: @aws_account.bus_unit, contact: @aws_account.contact, desc: @aws_account.desc, id: @aws_account.id, name: @aws_account.name } }
    end

    assert_redirected_to aws_account_url(AwsAccount.last)
  end

  test "should show aws_account" do
    get aws_account_url(@aws_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_aws_account_url(@aws_account)
    assert_response :success
  end

  test "should update aws_account" do
    patch aws_account_url(@aws_account), params: { aws_account: { audit_time: @aws_account.audit_time, bus_unit: @aws_account.bus_unit, contact: @aws_account.contact, desc: @aws_account.desc, id: @aws_account.id, name: @aws_account.name } }
    assert_redirected_to aws_account_url(@aws_account)
  end

  test "should destroy aws_account" do
    assert_difference('AwsAccount.count', -1) do
      delete aws_account_url(@aws_account)
    end

    assert_redirected_to aws_accounts_url
  end
end
