require 'spec_helper'

describe Spree::Promotion::Actions::CreateMiscLineItems do
  let(:order) { create(:order) }
  let(:action) { Spree::Promotion::Actions::CreateMiscLineItems.create }
  let(:promotion) { stub_model(Spree::Promotion) }
  let(:shirt) { create(:variant) }

  context "#perform" do
    before do
      action.stub :promotion => promotion
      action.promotion_action_misc_line_items.create!(
        :variant => shirt,
        :quantity => 1,
        :price => 0.0,
        :name => 'GWP'
      )
    end

    context "order is eligible" do
      before do
        promotion.stub :eligible? => true
      end

      it "adds misc line items to order with correct variant and quantity" do
        action.perform(:order => order)
        order.misc_line_items.count.should == 1
        line_item = order.misc_line_items.where(lineitemeable_id: shirt.id).first
        line_item.should_not be_nil
        line_item.quantity.should == 1
        order.misc_line_items.promotion.eligible.count.should == 1
      end

      it "does not add misc line items if already exists" do
        action.perform(:order => order)
        line_item = order.misc_line_items.where(lineitemeable_id: shirt.id).first
        line_item.should_not be_nil
        action.perform(:order => order)
        line_item.reload
        line_item.quantity.should == 1
        order.misc_line_items.promotion.eligible.count.should == 1
      end

      it "adds misc line item if existing line item is not a promotion" do
        action.perform(:order => order)
        line_item = order.misc_line_items.where(lineitemeable_id: shirt.id).first
        line_item.should_not be_nil
        line_item.update_attributes(promotion: false)
        action.perform(:order => order)
        order.misc_line_items.count.should == 2
        order.misc_line_items.promotion.eligible.count.should == 1
      end

      it "does not readd item if item has been marked inelgible" do
        action.perform(:order => order)
        line_item = order.misc_line_items.where(lineitemeable_id: shirt.id).first
        line_item.should_not be_nil
        line_item.update_attributes(eligible: false)
        action.perform(:order => order)
        order.misc_line_items.count.should == 1
        order.misc_line_items.promotion.eligible.count.should == 0
      end
    end

    context "order is ineligible" do
      before do
        promotion.stub :eligible? => false
      end

      it "does not add misc line item if inelegible" do
        action.perform(:order => order)
        order.misc_line_items.count.should == 0
      end

      it "removed items if it order becomes inelegible" do
        promotion.stub :eligible? => true
        action.perform(:order => order)
        order.misc_line_items.count.should == 1
        promotion.stub :eligible? => false
        action.perform(:order => order)
        order.misc_line_items.count.should == 0
      end
    end
  end
end