class Vote < ApplicationRecord
  # Associations
  belongs_to :product, class_name: 'Spree::Product'

  # Validations
  validates :user_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :star, presence: true,
                   numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, length: { maximum: 1000 }, allow_blank: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_rating, ->(rating) { where(star: rating) }
  scope :for_product, ->(product_id) { where(product_id: product_id) }

  # Class methods
  def self.average_rating
    average(:star).to_f.round(1)
  end

  def self.rating_distribution
    group(:star).count
  end
end
