require "application_system_test_case"

class AwsAccountsTest < ApplicationSystemTestCase
  setup do
    @aws_account = aws_accounts(:one)
  end

  test "visiting the index" do
    visit aws_accounts_url
    assert_selector "h1", text: "Aws Accounts"
  end

  test "creating a Aws account" do
    visit aws_accounts_url
    click_on "New Aws Account"

    fill_in "Audit time", with: @aws_account.audit_time
    fill_in "Bus unit", with: @aws_account.bus_unit
    fill_in "Contact", with: @aws_account.contact
    fill_in "Desc", with: @aws_account.desc
    fill_in "Id", with: @aws_account.id
    fill_in "Name", with: @aws_account.name
    click_on "Create Aws account"

    assert_text "Aws account was successfully created"
    click_on "Back"
  end

  test "updating a Aws account" do
    visit aws_accounts_url
    click_on "Edit", match: :first

    fill_in "Audit time", with: @aws_account.audit_time
    fill_in "Bus unit", with: @aws_account.bus_unit
    fill_in "Contact", with: @aws_account.contact
    fill_in "Desc", with: @aws_account.desc
    fill_in "Id", with: @aws_account.id
    fill_in "Name", with: @aws_account.name
    click_on "Update Aws account"

    assert_text "Aws account was successfully updated"
    click_on "Back"
  end

  test "destroying a Aws account" do
    visit aws_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aws account was successfully destroyed"
  end
end
