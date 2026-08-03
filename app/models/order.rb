class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :created_by, class_name: "OrderReceiver", optional: true, foreign_key: "created_by_id"
  belongs_to :updated_by, class_name: "OrderReceiver", optional: true, foreign_key: "updated_by_id"
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_many :status_changes, dependent: :destroy

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  enum :status, {
    pending: 0,
    confirmed: 1,
    processing: 2,
    cancelled: 3,
    shipped: 4,
    delivered: 5
  }

  STATUS_TRANSITIONS = {
    'pending' => ['confirmed', 'cancelled'],
    'confirmed' => ['processing', 'cancelled'],
    'processing' => ['shipped', 'cancelled'],
    'shipped' => ['delivered'],
    'delivered' => [],
    'cancelled' => []
  }

  def can_transition_to?(new_status)
    return false if new_status.blank?
    return true if status == new_status
    STATUS_TRANSITIONS[status]&.include?(new_status)
  end

  def completed?
    delivered? || cancelled?
  end

  def record_status_change(old_status, new_status, changed_by)
    status_changes.create!(
      old_status: old_status.to_s,
      new_status: new_status.to_s,
      changed_by_id: changed_by&.id
    )
  end
  
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_paid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :pending_orders, -> { where(status: [:pending, :confirmed]) }
  
  def subtotal
    order_items.sum('quantity * price_per_unit')
  end
  
  before_save :calculate_total, if: -> { total_price.nil? }
  before_save :set_updated_by, if: -> { updated_by_id_changed? }
  
  private
  
  def calculate_total
    self.total_price = subtotal
  end
  
  def set_updated_by
    # This will be set in controller, but we can auto-set if needed
  end
end