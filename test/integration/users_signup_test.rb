require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name: " ",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar" }
    end
    assert_template "users/new"
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "Valid signup information with account activation" do
    get signup_path
    name = "Example User"
    email = "user@example.com"
    password = "foobar"
    assert_difference 'User.count', 1 do
      post users_path, user: { name: name,
                              email: email,
                              password: password,
                              password_confirmation: password }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated? #Make certain that the user is not activated yet.
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Index page
    # Log in as a valid user
    log_in_as(users(:michael))
    # Unactivated user is on the second page
    get users_path, page: 2
    assert_no_match user.name, response.body
    # Profile page
    get user_path(user)
    assert_redirected_to root_url
    # Log out valid user
    delete logout_path

    # Invalid activation token prevents logging in.
    get edit_account_activation_path('invalid token')
    assert_not is_logged_in?

    # Correct token, but invalid email preventing logging in.
    get edit_account_activation_path(user.activation_token, email:"wrong email")
    assert_not is_logged_in?

    # Correct token and correct email allowing logging in.
    get edit_account_activation_path(user.activation_token, email:user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
