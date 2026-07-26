class OrderReceiver < ApplicationRecord
  self.primary_key = :id
  has_secure_password
  
  enum :status, { inactive: 0, active: 1 }
  
  validates :id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end