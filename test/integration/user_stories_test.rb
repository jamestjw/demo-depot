require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  # test "the truth" do
  #   assert true
  # end

  test 'buying a product' do
    start_order_count = Order.count 
    ruby_book = products(:ruby)

    # A user goes to the store index 
    get "/"
    assert_response :success
    assert_select 'h1', 'Your Pragmatic Catalog'

    # He selects a product, adding it to his cart
    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success 

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.count
    assert_equal ruby_book, cart.line_items[0].product

    # He then proceeds to check out 
    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'
    
    perform_enqueued_jobs do
      post "/orders", params: {
        order: {
          name: 'Eva Green',
          address: 'Tour Eiffel, Paris',
          email: 'egreen@hw.com',
          pay_type: 'Check'
        }
      }

      # Follow redirect to store page, and make sure that previously created cart has been removed.
      follow_redirect!

      assert_response :success
      assert_select 'h1', "Your Pragmatic Catalog"
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size

      # Check database to inspect the order that we just created
      assert_equal start_order_count + 1, Order.count
      order = Order.last

      assert_equal 'Eva Green', order.name
      assert_equal 'Tour Eiffel, Paris', order.address
      assert_equal 'egreen@hw.com', order.email
      assert_equal 'Check', order.pay_type

      assert_equal 1, order.line_items.size
      line_item = order.line_items.last
      assert_equal ruby_book, line_item.product

      # Check if email was successfully sent
      mail = ActionMailer::Base.deliveries.last
      assert_equal ['egreen@hw.com'], mail.to
      assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
      assert_equal 'Amazon Bookstore Order Confirmation', mail.subject
    end
  end
end
