require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check routing number" do
    visit store_index_url

    first('.catalog div.price_line').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Woo Yan'
    fill_in 'order_address', with: 'Regent Street, London'
    fill_in 'order_email', with: 'leongwoo@kaodim.com'

    assert_no_selector "#order_routing_number"

    select 'Check', from: 'order_pay_type'
    assert_selector "#order_routing_number"
  end
end
