require 'test_helper'
class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "MyNextGenHealth"
    assert_equal full_title("Help"), "Help | MyNextGenHealth"
  end
end
