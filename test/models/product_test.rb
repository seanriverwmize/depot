require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def new_product(image_url)
    product = Product.new(
      title: 'TestTitleee',
      description: 'TestDescription',
      price: 1,
      image_url: image_url
    )
  end

  test "product attributes must exist" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be greater than 0.01" do
    product = Product.new(
                          title: 'exampletitle',
                          description: 'exampledescription',
                          image_url: 'example.png')
    product.price = -1
    assert product.invalid?
    assert_equal ["must be at least 0.01"],
      product.errors[:price]
    product.price = 0
    assert_equal ["must be at least 0.01"],
      product.errors[:price]
    product.price = 1
    assert product.valid?
  end

  test "image_url must be correct format" do
    ok = %w{ ex.png ex.jpg lorem.jpg EX.JPG Ex.Png https://fndfdf.com/dfd/dfd/yop.gif }
    bad = %w{ ex.gif.large ex.word ex.doc ex.png/large }
    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} should be valid"
    end
    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} should be invalid"
    end
  end

  test "product title must be unique" do
    product = Product.new(title: products(:bike).title,
                          description: 'boopy description',
                          image_url: 'lorem.jpg',
                          price: 100)
    assert product.invalid?
    assert_equal ["must be unique"], product.errors[:title]
  end

  test "title must be between 10 and 80 characters" do
    product = products(:shorttitle)
    assert product.invalid?
    assert_equal ["must be between 10 and 80 characters long."], product.errors[:title]
    product = products(:longtitle)
    assert product.invalid?
    assert_equal ["must be between 10 and 80 characters long."], product.errors[:title]
    product = products(:one)
    assert product.valid?
  end

  test "product must have no dependent line items" do
    product = products(:two)
    product.destroy
    assert_equal ["Line Item(s) Present"], products(:two).errors[:base]
  end
end
