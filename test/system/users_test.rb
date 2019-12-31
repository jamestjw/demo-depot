require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper
  
  setup do
    @user = users(:one)
  end

  test "visiting the user index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_on "New User"

    fill_in "Name", with: 'admin2'
    fill_in "user_password", with: 'secret'
    fill_in "user_password_confirmation", with: 'secret'
    click_on "Create User"

    assert_text "User admin2 was successfully created"
  end

  test "updating a User" do
    visit users_url
    click_on "Edit", match: :first

    fill_in "Name", with: @user.name
    fill_in "user_oldpassword", with: 'secret'
    fill_in "user_password", with: 'secret2'
    fill_in "user_password_confirmation", with: 'secret2'
    click_on "Update User"

    assert_text "User #{@user.name} was successfully updated"
  end

  test "destroying a User" do
    visit users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end
end
