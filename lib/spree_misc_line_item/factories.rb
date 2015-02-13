FactoryGirl.define do
  factory :misc_line_item, class: Spree::MiscLineItem do
    order
    quantity 1
    price 0.0
    name 'Misc Line Item'
    association(:lineitemeable, factory: :variant)
  end

  factory :order_with_misc_line_items, parent: :order_with_totals do
    after(:create) do |order|
      create(:misc_line_item, order: order)
      order.misc_line_items.reload
    end
  end
end
