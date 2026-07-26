class Supplier < ApplicationRecord
  has_many :purchases
  has_many :products, through: :purchases
  
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end