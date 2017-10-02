module Spree
  class AdHocOptionValuesLineItem  < ActiveRecord::Base
    belongs_to :ad_hoc_option_value
    belongs_to :line_item
    has_one :ad_hoc_option_values_line_item_customization
  end
end
