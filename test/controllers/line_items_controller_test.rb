require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:two)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post line_items_url, params: { product_id: products(:ruby).id } 
    end

    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'td', 'Programming Ruby 1.9'
    # assert_redirected_to cart_path(assigns(:line_item).cart)
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  test "should update line_item" do
    patch line_item_url(@line_item), params: { line_item: { product_id: @line_item.product_id } }
    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    curr_cart = @line_item.cart
    assert_difference('LineItem.count', -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to cart_path(curr_cart)
  end

  test "add duplicate products" do
    assert_difference('LineItem.count', 1) do
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:ruby).id }
    end 
   
    assert_redirected_to cart_path(session[:cart_id])
  end

  test "add unique products" do
    assert_difference('LineItem.count', 3) do
      post line_items_url, params: { product_id: products(:ruby).id }
      post line_items_url, params: { product_id: products(:two).id }
      post line_items_url, params: { product_id: products(:one).id }
    end 
    
    assert_redirected_to cart_path(session[:cart_id])
  end  
end
