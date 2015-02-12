class Spree::MiscLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :tax_category
  belongs_to :lineitemeable, polymorphic: true
  has_many :adjustments, as: :adjustable, dependent: :destroy

  before_validation :copy_price
  before_validation :copy_tax_category

  def copy_price
    if self.has_variant?
      self.variant_price = lineitemeable.variant_price if self.variant_price.nil?
      self.variant_price = lineitemeable.cost_price if self.cost_price.nil?
      self.currency = lineitemeable.currency if currency.nil?
    end
  end

  def copy_tax_category
    if self.has_variant?
      self.tax_category = lineitemeable.product.tax_category
    end
  end

  def has_variant?
    self.lineitemeable.is_a? Spree::Variant
  end

  def amount
    price * quantity
  end
  alias total amount

  def single_money
    Spree::Money.new(price, { currency: currency })
  end
  alias single_display_amount single_money

  def money
    Spree::Money.new(amount, { currency: currency })
  end
  alias display_total money
  alias display_amount money

  def sufficient_stock?
    self.has_variant? ? Stock::Quantifier.new(self.lineitemeable_id).can_supply?(quantity) : true
  end

  def insufficient_stock?
    !sufficient_stock?
  end

  def insert_in_shipment(shipment)
    if self.has_variant?
      Spree::OrderInventory.new(self.order).send(:add_to_shipment, shipment, self.lineitemeable, self.quantity)
    end
  end
end
