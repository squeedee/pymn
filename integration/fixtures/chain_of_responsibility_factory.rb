require 'pymn/chain_of_responsibility/factory'

class Promotion
  attr_reader :description

  def initialize(attributes={})
    @description = attributes[:description]
  end
end

class Product
  attr_reader :price, :description, :discount

  def initialize(attributes={})
    @price = attributes[:price]
    @discount = attributes[:discount]
    @description = attributes[:description]
  end

  def discounted?
    !@discount.nil? && @discount > 0.0
  end
end

class ProductPresenter
  include Pymn::ChainOfResponsibility::Factory

  def self.build(product)
    new(product)
  end

  responsibility :build do |model| 
    model.is_a?(Product)
  end

  def initialize(product)
    @product = product
  end

  def description
    @product.description
  end

  def price
    "$%.2f" % @product.price
  end
end

class SpecialsPresenter
  include Pymn::ChainOfResponsibility::Factory

  def self.build(product)
    new(product)
  end

  responsibility :build do |model| 
    model.is_a?(Product) &&
      model.discounted?
  end

  def initialize(product)
    @product = product
  end

  def description
    "On Sale! - #{@product.description}"
  end

  def price
    "$%.2f" % (@product.price * @product.discount / 100)
  end
end

class PromotionPresenter
  include Pymn::ChainOfResponsibility::Factory

  def self.build(promotion)
    new(promotion)
  end

  responsibility :build do |model| 
    model.is_a?(Promotion)
  end

  def initialize(product)
    @product = product
  end

  def description
    @product.description
  end
end

class ProductsPresenter
  attr_accessor :products

  def self.build_chain
    return @chain if @chain

    @chain = SpecialsPresenter.create_factory.
      add_handler(ProductPresenter.create_factory).
      add_handler(PromotionPresenter.create_factory)
  end

  def initialize(product_list)
    @products = build_products(product_list)
  end

  private

  def build_products(product_list)
    product_list.map do |item|
      self.class.build_chain.build(item)
    end
  end
end
