module Spree
  module TaxonomyDecorator
    def self.prepended(base)
      # Add ransackable attributes for search functionality
      base.class_eval do
        def self.ransackable_attributes(auth_object = nil)
          %w[name description created_at updated_at]
        end
      end
    end

    # Custom method to get formatted description
    def formatted_description
      description.presence || "No description available"
    end

    # Method to check if taxonomy has description
    def has_description?
      description.present?
    end
  end
end

Spree::Taxonomy.prepend Spree::TaxonomyDecorator 