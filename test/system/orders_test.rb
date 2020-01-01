require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  test "check routing number" do
    LineItem.delete_all
    Order.delete_all
    assert_equal 0, Order.all.size

    visit store_index_url

    first('.catalog div.price_line').click_on 'Add to Cart'

    click_on 'Checkout'

    fill_in 'order_name', with: 'Woo Yan'
    fill_in 'order_address', with: 'Regent Street, London'
    fill_in 'order_email', with: 'leongwoo@kaodim.com'

    assert_no_selector "#order_routing_number"

    select 'Check', from: 'order_pay_type'
    assert_selector "#order_routing_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    perform_enqueued_jobs do 
      click_button "Place Order"
    end

    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal 'Woo Yan',      order.name
    assert_equal 'Regent Street, London',  order.address
    assert_equal 'leongwoo@kaodim.com', order.email
    assert_equal "Check",            order.pay_type
    assert_equal 1, order.line_items.size

    mail = ActionMailer::Base.deliveries.last
    assert_equal ['leongwoo@kaodim.com'],                 mail.to
    assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
    assert_equal "Amazon Bookstore Order Confirmation", mail.subject

  end
end
