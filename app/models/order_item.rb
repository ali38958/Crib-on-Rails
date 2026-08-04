class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :quantity_not_exceed_stock, on: :create
  
  before_save :set_price_per_unit
  after_create :reduce_product_stock
  
  private
  
  def set_price_per_unit
    self.price_per_unit ||= product.current_price
  end
  
  def quantity_not_exceed_stock
    if product && quantity > product.quantity
      errors.add(:quantity, "only #{product.quantity} available in stock")
    end
  end
  
  def reduce_product_stock
    product.decrement!(:quantity, quantity)
  end
end