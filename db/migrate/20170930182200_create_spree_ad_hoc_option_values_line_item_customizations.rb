class CreateSpreeAdHocOptionValuesLineItemCustomizations < ActiveRecord::Migration[4.2]
  def self.up
    create_table :spree_ad_hoc_option_values_line_item_customizations do |t|
      t.string :value
      t.belongs_to :ad_hoc_option_values_line_item
    end
  end

  def self.down
    drop_table :spree_ad_hoc_option_values_line_item_customizations
  end
end
