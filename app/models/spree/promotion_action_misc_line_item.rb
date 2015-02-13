class Spree::PromotionActionMiscLineItem < ActiveRecord::Base
  belongs_to :promotion_action, class_name: 'Spree::Promotion::Actions::CreateMiscLineItems'
  belongs_to :variant, class_name: 'Spree::Variant'
end
