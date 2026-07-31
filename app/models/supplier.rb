class Supplier < ApplicationRecord
  has_many :purchases
  has_many :products, through: :purchases
  
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  
  scope :search, ->(query) {
    if query.present?
      pattern = "%#{query}%"
      where(
        "LOWER(name) LIKE LOWER(?) OR LOWER(phone) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?) OR LOWER(contact_person) LIKE LOWER(?)",
        pattern, pattern, pattern, pattern
      )
    end
  }
end