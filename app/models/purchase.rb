class Purchase < ApplicationRecord
  belongs_to :supplier, counter_cache: :purchases_count
  belongs_to :product
  
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  enum :status, {
    pending: 0,
    received: 1,
    cancelled: 2
  }, default: :pending
  
  after_create :update_product_stock
  
  scope :search, ->(query) {
    if query.present?
      pattern = "%#{query}%"
      joins(:supplier).where(
        "LOWER(suppliers.name) LIKE LOWER(?) OR CAST(purchases.id AS TEXT) LIKE LOWER(?)",
        pattern, pattern
      )
    end
  }
  
  scope :date_range, ->(from, to) {
    if from.present? && to.present?
      where(created_at: Date.parse(from).beginning_of_day..Date.parse(to).end_of_day)
    elsif from.present?
      where("created_at >= ?", Date.parse(from).beginning_of_day)
    elsif to.present?
      where("created_at <= ?", Date.parse(to).end_of_day)
    end
  }
  
  private
  
  def update_product_stock
    product.add_stock(quantity) if received?
  end
end