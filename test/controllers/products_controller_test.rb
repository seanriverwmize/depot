require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @title = "The Enchirideon, Edition number #{rand(1000)}"
  end

  test "should get index" do
    get products_url
    assert_response :success
    assert_select 'h1', 'Amazing Bike'
    assert_select 'tr.list_line_odd', 3
    assert_select 'tr.list_line_even', 2
  end

  test "should get new" do
    get new_product_url
    assert_response :success
    assert_select 'form', true
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { description: @product.description, image_url: @product.image_url, price: @product.price, title: @title } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
    assert_select 'form', true
  end

  test "should update product" do
    patch product_url(@product), params: { product: { description: @product.description, image_url: @product.image_url, price: @product.price, title: @title } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product, no line items present" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end
    assert_redirected_to products_url
  end

  test "should not destroy product when line items are present" do
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end
    assert_redirected_to products_url
  end

end
