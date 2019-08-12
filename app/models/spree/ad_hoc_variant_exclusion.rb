module Spree
  class AdHocVariantExclusion < ApplicationRecord
    belongs_to :product
    has_many :excluded_ad_hoc_option_values, dependent: :destroy
  end
end
