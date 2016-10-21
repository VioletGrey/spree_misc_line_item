module Spree
  class Promotion
    module Actions
      class CreateMiscLineItems < PromotionAction
        has_many :promotion_action_misc_line_items, foreign_key: :promotion_action_id
        accepts_nested_attributes_for :promotion_action_misc_line_items

        delegate :eligible?, :to => :promotion

        preference :callout, :string, default: ""

        attr_accessor :order

        def perform(options = {})
          self.order = options[:order].reload
          if self.eligible? self.order
            create_eligible_misc_line_items
          else
            set_ineligible_misc_line_items
          end
        end

        def create_eligible_misc_line_items
          promotion_action_misc_line_items.each do |item|
            if self.order.misc_line_items.promotion.pluck(:lineitemeable_id).include? item.variant_id
              next
            else
              self.order.misc_line_items.create({
                quantity: item.quantity,
                price: item.price,
                eligible: true,
                promotion: true,
                name: item.name,
                lineitemeable: item.variant
              })
            end
          end
        end

        def set_ineligible_misc_line_items
          self.order.misc_line_items.promotion.where(lineitemeable_id: promotion_action_misc_line_items.pluck(:variant_id)).destroy_all
        end
      end
    end
  end
end
