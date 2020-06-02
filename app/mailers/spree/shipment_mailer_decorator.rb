module Spree
  module ShipmentMailerDecorator
    def self.prepended(base)
      base.helper Spree::BaseHelper
    end
  end
end

::Spree::ShipmentMailer.prepend(Spree::ShipmentMailerDecorator)
