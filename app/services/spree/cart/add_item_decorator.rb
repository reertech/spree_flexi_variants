# Almost copypaste from order_contents_decorator
module AddItemDecorator
  prepend Spree::ServiceModule::Base

  private

  def add_to_line_item(order:, variant:, quantity: nil, options: {})
    options ||= {}
    quantity ||= 1

    options.permit(ad_hoc_option_values: [], product_customizations: [], ad_hoc_option_value_customizations: [])
    options_params = options.is_a?(ActionController::Parameters) ? options : ActionController::Parameters.new(options.to_h)
    options_params.permit(Spree::PermittedAttributes.line_item_attributes).to_h.merge(currency: order.currency)

    line_item = order.line_items.new(quantity: quantity, variant: variant)
    line_item_created = line_item.nil?

    product_customizations_values = options[:product_customizations] || []
    line_item.product_customizations = product_customizations_values
    product_customizations_values.each { |product_customization| product_customization.line_item = line_item }
    product_customizations_values.map(&:save) # it is now safe to save the customizations we built

    # find, and add the configurations, if any.  these have not been fetched from the db yet.              line_items.first.variant_id
    # we postponed it (performance reasons) until we actually know we needed them
    ad_hoc_option_value_ids = (!!options[:ad_hoc_option_values] ? options[:ad_hoc_option_values] : [])
    product_option_values = ad_hoc_option_value_ids.map do |cid|
      Spree::AdHocOptionValue.find(cid) if cid.present?
    end.compact
    line_item.ad_hoc_option_values = product_option_values

    # add customizations for ad hoc options.
    # terrible code, terrible gem (╯°□°）╯︵ ┻━┻
    ad_hoc_option_value_customizations = (!!options[:ad_hoc_option_value_customizations] ? options[:ad_hoc_option_value_customizations] : [])
    ad_hoc_option_value_customizations.map do |param|
      value_id = param.keys.first
      customization = param.values.first
      ad_hoc_li =
        line_item.ad_hoc_option_values_line_items.detect { |item| item.ad_hoc_option_value_id == value_id }
      ad_hoc_li.ad_hoc_option_values_line_item_customization =
        Spree::AdHocOptionValuesLineItemCustomization.new(value: customization)
    end

    offset_price = product_option_values.map(&:price_modifier).compact.sum + product_customizations_values.map { |product_customization| product_customization.price(variant) }.compact.sum

    if order.currency
      line_item.currency = order.currency unless order.currency.blank?
      line_item.price = variant.price_in(order.currency).amount + offset_price
    else
      line_item.price = variant.price + offset_price
    end

    line_item.target_shipment = options[:shipment] if options.has_key? :shipment

    return failure(line_item) unless line_item.save

    ::Spree::TaxRate.adjust(order, [line_item.reload]) if line_item_created
    success(order: order, line_item: line_item, line_item_created: line_item_created, options: options)
  end
end

Spree::Cart::AddItem.prepend(AddItemDecorator)
