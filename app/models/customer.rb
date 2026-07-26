class Customer < ApplicationRecord
  has_many :orders
  
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
  
  def total_spent
    orders.sum(:total_price)
  end
end