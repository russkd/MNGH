require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "passwords reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'

    #Invalid email
    post password_resets_path, password_reset: { email: "" }
    assert_not flash.empty?
    assert_template 'password_resets/new'

    # Valid email
    post password_resets_path, password_reset: { email: @user.email }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    # Password_reset_form
    user = assigns(:user)
    # Wrong email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url

    # Inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)

    #Right email, but wrong reset token.
    get edit_password_reset_path("wrong token", email: user.email)
    assert_redirected_to root_url

    #Wrong email, but correct reset token.
    get edit_password_reset_path(user.reset_token, 'wrong email')
    assert_redirected_to root_url

    # Right email, and correct reset token.
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email

    #Invalid password and combination
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: { password: "foobar",
              password_confirmation: "foobaz" }
    assert_select 'div#error_explanation'

    #Blank password
    patch password_reset_path(user.reset_token),
      email: user.email,
      user: { password: "",
              password_confirmation: "foobar" }
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    # Valid password and confirmation
      patch password_reset_path(user.reset_token),
        email: user.email,
        user: { password: "foobar",
                password_confirmation: "foobar" }
      assert is_logged_in?
      assert_not flash.empty?
      assert_redirected_to user
  end
end
