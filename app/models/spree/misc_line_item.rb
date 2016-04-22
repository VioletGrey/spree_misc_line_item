class Spree::MiscLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :tax_category
  belongs_to :lineitemeable, polymorphic: true
  has_many :adjustments, as: :adjustable, dependent: :destroy

  before_validation :copy_price
  before_validation :copy_tax_category

  scope :eligible, -> { where(eligible: true) }
  scope :promotion, -> { where(promotion: true) }

  def copy_price
    if self.has_variant?
      self.variant_price = lineitemeable.price if self.variant_price.nil?
      self.cost_price = lineitemeable.cost_price if self.cost_price.nil?
      self.currency = lineitemeable.currency if currency.nil?
    else
      self.variant_price = 0.0 if self.variant_price.nil?
      self.cost_price = 0.0 if self.cost_price.nil?
      self.currency = 'USD' if currency.nil?
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

  def display_variant_price
    Spree::Money.new(variant_price, { currency: currency })
  end

  def money
    Spree::Money.new(amount, { currency: currency })
  end
  alias display_total money
  alias display_amount money

  def sufficient_stock?
    self.has_variant? ? Spree::Stock::Quantifier.new(self.lineitemeable_id).can_supply?(quantity) : true
  end

  def insufficient_stock?
    !sufficient_stock?
  end

  def unstock(shipment)
    if self.has_variant? && self.order.completed?
      shipment.stock_location.unstock(lineitemeable, self.quantity, shipment)
    end
  end
end
