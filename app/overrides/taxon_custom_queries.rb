# frozen_string_literal: true

module TaxonCustomQueries
  Deface::Override.new(
    virtual_path: "spree/taxons/show",
    name: "taxon_custom_queries",
    insert_after: "[data-hook='taxon_products']",
    text: "<%= render 'spree/taxons/custom_queries', taxon: @taxon %>"
  )

  def featured(limit = 3)
    all_products.featured.order('RANDOM()').limit(limit)
  end

  def all_products_except(product_ids)
    all_products.where.not(id: product_ids)
  end

  Spree::Taxon.prepend self
end
