module Spree
  class AdHocOptionValuesLineItem  < ApplicationRecord
    belongs_to :ad_hoc_option_value
    belongs_to :line_item
    has_one :ad_hoc_option_values_line_item_customization

    alias_attribute :customization, :ad_hoc_option_values_line_item_customization

    def humanable_value
      if customization
        customization.value
      else
        ad_hoc_option_value.try(:option_value).try(:presentation)
      end
    end

    def humanable_presentation
      ad_hoc_option_value.try(:option_value).try(:option_type).try(:presentation)
    end
  end
end
