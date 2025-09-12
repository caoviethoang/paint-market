# frozen_string_literal: true

module Spree
  module PropertyDecorator
    def self.prepended(base)
      base.class_eval do
        has_many :property_values, dependent: :destroy, class_name: 'PropertyValue'
        accepts_nested_attributes_for :property_values, allow_destroy: true
        
        # Scope to get properties with values
        scope :with_values, -> { joins(:property_values).distinct }
        
        # Get ordered values for this property
        def ordered_values
          property_values.ordered
        end
        
        # Get value options for select
        def value_options
          ordered_values.pluck(:value, :display_name)
        end
      end
    end
  end
end

Spree::Property.prepend Spree::PropertyDecorator