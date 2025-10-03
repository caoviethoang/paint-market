Rails.application.config.to_prepare do
  Spree::Price.class_eval do
    _validators[:amount].each do |v|
      if v.is_a?(ActiveModel::Validations::NumericalityValidator)
        _validators[:amount].delete(v)
      end
    end

    validates :amount,
              numericality: { greater_than_or_equal_to: 0,
                              less_than_or_equal_to: 500_000_000 }
  end

  Spree::Variant.class_eval do
    _validators[:cost_price].each do |v|
      if v.is_a?(ActiveModel::Validations::NumericalityValidator)
        _validators[:cost_price].delete(v)
      end
    end

    validates :cost_price,
              numericality: { greater_than_or_equal_to: 0,
                              less_than_or_equal_to: 500_000_000 }
  end
end
