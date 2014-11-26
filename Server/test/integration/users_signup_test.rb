require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  
  test "invalid signup information" do
    get register_path
    assert_no_difference 'User.count' do
      post users_path, user: { firstName:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end
  
  test "valid signup information" do
    get register_path
    assert_no_difference 'User.count' do
      post users_path, user: { firstName:  "a",
                               email: "user@valid",
                               password:              "foooooof",
                               password_confirmation: "foooooof" }
    end
    assert_template 'users/new'
    assert is_logged_in? # fails and I don't know why
  end
end
