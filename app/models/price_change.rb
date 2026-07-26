class PriceChange < ApplicationRecord
  # Relationships
  belongs_to :product
  
  # Validations
  validates :old_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :new_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :last_week, -> { where('created_at >= ?', 1.week.ago) }
  scope :for_product, ->(product_id) { where(product_id: product_id) }
  
  # Custom method to show price change
  def price_difference
    new_price - old_price
  end
  
  def price_change_percentage
    return 0 if old_price.zero?
    ((new_price - old_price) / old_price * 100).round(2)
  end
  
  def increased?
    new_price > old_price
  end
  
  def decreased?
    new_price < old_price
  end
  
  def same?
    new_price == old_price
  end
end