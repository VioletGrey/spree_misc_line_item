Spree::Order.class_eval do
  has_many :misc_line_items, dependent: :destroy
  has_many :misc_line_item_adjustments, through: :misc_line_items, source: :adjustments

  accepts_nested_attributes_for :misc_line_items

  def display_misc_item_total
    Spree::Money.new(misc_item_total, { currency: currency })
  end

  def misc_item_total
    misc_line_items.map(&:amount).sum
  end
end