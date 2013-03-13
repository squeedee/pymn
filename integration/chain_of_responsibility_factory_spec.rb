require 'spec_helper'
require 'fixtures/chain_of_responsibility_factory'

describe "Chain Of Responsibility as a class method" do
  let(:items) { 
    [
      Product.new(
        :price => 5.0,
        :description => "Hat with wide brim"
      ),
      Product.new(
        :price => 10.20,
        :description => "Office chair",
        :discount => 50
      ),
      Promotion.new(
        :description => "Add our after-sales care and receive a further 10% off your order"
      )
    ]
  }

  subject(:products) { ProductsPresenter.new(items).products }

  it "builds a ProductPresenter for a normal product" do
    products[0].description.should == "Hat with wide brim"
    products[0].price.should == "$5.00"
  end

  it "builds a SpecialsPresenter for a product on sale" do
    products[1].description.should == "On Sale! - Office chair"
    products[1].price.should == "$5.10"
  end

  it "builds a PromotionPresenter for a promotion" do
    products[2].description.should == "Add our after-sales care and receive a further 10% off your order"
  end
end

