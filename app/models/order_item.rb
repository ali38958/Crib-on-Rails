class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price_per_unit, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  before_save :set_price_per_unit
  
  private
  
  def set_price_per_unit
    self.price_per_unit ||= product.current_price
  end
end