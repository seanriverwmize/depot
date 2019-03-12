require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get store_index_url
    assert_response :success
    assert_select 'nav.side_nav a', minimum: 4
    assert_select 'main ul.catalog li', 5 #matches quantity in products.yml
    assert_select 'h2', 'Amazing Book'
    assert_select '.price', %r{\$[,\d]+\.\d\d}
  end

end
