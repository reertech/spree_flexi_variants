module Spree
  module Environment
    module CalculatorsDecorator
      attr_accessor :product_customization_types
    end
  end
end

::Spree::Environment::Calculators.prepend(Spree::Environment::CalculatorsDecorator)
