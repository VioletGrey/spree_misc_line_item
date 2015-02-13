require 'spec_helper'

describe Spree::MiscLineItem do
  let(:order) { create :order_with_misc_line_items }
  let(:misc_line_item) { order.misc_line_items.first }

  context '#copy_price' do
    it "copies over a variant's prices" do
      misc_line_item.variant_price = nil
      misc_line_item.cost_price = nil
      misc_line_item.currency = nil
      misc_line_item.copy_price
      variant = misc_line_item.lineitemeable
      misc_line_item.variant_price.should == variant.price
      misc_line_item.cost_price.should == variant.cost_price
      misc_line_item.currency.should == variant.currency
    end
  end

  context '#copy_tax_category' do
    it "copies over a variant's tax category" do
      misc_line_item.tax_category = nil
      misc_line_item.copy_tax_category
      misc_line_item.tax_category.should == misc_line_item.lineitemeable.product.tax_category
    end
  end

  context "has_variant" do
    it "returns true" do
      expect(misc_line_item.has_variant?).to be_true
    end

    it "returns false" do
      misc_line_item.update_attributes(lineitemeable: nil)
      expect(misc_line_item.has_variant?).to be_false
    end
  end

  context "unstock" do
    it "unstocks item" do
      variant = misc_line_item.lineitemeable
      variant.stock_items.update_all count_on_hand: 5, backorderable: false
      order.create_proposed_shipments
      shipment = order.shipments.first
      Spree::Order.any_instance.stub(:completed?).and_return(true)
      misc_line_item.unstock(shipment)
      new_count = misc_line_item.lineitemeable.stock_items.first.reload.count_on_hand
      expect(new_count).to eq(4)
    end
  end
end
