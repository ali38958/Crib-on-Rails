class Supplier < ApplicationRecord
  has_many :purchases
  has_many :products, through: :purchases
  
  validates :name, presence: true
  validates :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  
  scope :search, ->(query) {
    if query.present?
      where("name ILIKE ? OR phone ILIKE ? OR email ILIKE ? OR contact_person ILIKE ?", 
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    end
  }
end