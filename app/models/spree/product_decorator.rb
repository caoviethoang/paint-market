module Spree
  module ProductDecorator
    def self.prepended(base)
      base.belongs_to :event, optional: true
      base.belongs_to :artist
      base.has_many :votes, dependent: :destroy

      base.validates :artist, presence: true
      base.validate :must_have_taxon
    end

    private

    def must_have_taxon
      if taxons.empty?
        errors.add(:taxons, "phải chọn ít nhất một thể loại (taxon)")
      end
    end
  end
end

Spree::Product.prepend Spree::ProductDecorator
