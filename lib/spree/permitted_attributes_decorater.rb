Spree::PermittedAttributes.module_eval do
  mattr_reader :misc_line_item_attributes

  @@misc_line_item_attributes = [:id, :order_id, :quantity, :price, :variant_price, :cost_price, :currency, :tax_category_id, :eligible, :promotion, :description, :name, :lineitemeable_id, :lineitemeable_type]
end