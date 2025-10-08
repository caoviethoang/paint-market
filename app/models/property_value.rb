# frozen_string_literal: true

class PropertyValue < ApplicationRecord
  belongs_to :property, class_name: 'Spree::Property'
  
  validates :value, presence: true, uniqueness: { scope: :property_id }
  validates :display_name, presence: true
  validates :position, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  scope :ordered, -> { order(:position, :display_name) }
  
  def to_s
    display_name
  end
end
