class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  has_many :products, through: :order_items
  
  enum :status, {
    pending: 0,
    confirmed: 1,
    processing: 2,
    cancelled: 3,
    shipped: 4,
    delivered: 5
  }
  
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :pending_orders, -> { where(status: [:pending, :confirmed]) }
  
  def subtotal
    order_items.sum('quantity * price_per_unit')
  end
  
  before_save :calculate_total
  
  private
  
  def calculate_total
    self.total_price = subtotal if total_price.nil?
  end
end