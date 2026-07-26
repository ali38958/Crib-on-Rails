class Product < ApplicationRecord
  belongs_to :category, optional: true
  has_many :purchases
  has_many :suppliers, through: :purchases
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :price_changes
  has_one_attached :image  # Add this
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :current_price, numericality: { greater_than_or_equal_to: 0 }
  
  scope :in_stock, -> { where("quantity > 0") }
  scope :out_of_stock, -> { where(quantity: 0) }
  
  before_update :track_price_change, if: :will_save_change_to_current_price?
  
  def in_stock?
    quantity > 0
  end
  
  def add_stock(amount)
    update(quantity: quantity + amount)
  end
  
  def price_history
    price_changes.recent
  end
  
  def price_history_count
    price_changes.count
  end
  
  def first_price
    price_changes.order(:created_at).first&.old_price || current_price
  end
  
  def price_trend
    changes = price_changes.recent.limit(5)
    return "No history" if changes.empty?
    
    if changes.all?(&:increased?)
      "📈 Increasing"
    elsif changes.all?(&:decreased?)
      "📉 Decreasing"
    else
      "🔄 Fluctuating"
    end
  end
  
  private
  
  def track_price_change
    if current_price != current_price_was
      price_changes.create!(
        old_price: current_price_was || 0,
        new_price: current_price
      )
    end
  end
end