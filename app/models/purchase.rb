class Purchase < ApplicationRecord
  belongs_to :supplier
  belongs_to :product
  
  validates :quantity, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  
  after_create :update_product_stock
  
  private
  
  def update_product_stock
    product.add_stock(quantity)
  end
end