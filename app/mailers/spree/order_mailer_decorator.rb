module Spree
  module OrderMailerDecorator
    def self.prepended(base)
      base.helper Spree::BaseHelper
    end
  end
end

::Spree::OrderMailer.prepend(Spree::OrderMailerDecorator)
