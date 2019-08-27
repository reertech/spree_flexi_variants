module AdHocUtils

  def ad_hoc_option_value_ids # (variant_id)
    ids = []
    params[:ad_hoc_option_values].to_unsafe_h.each do |ignore, product_option_value_id|
      # pov=ProductOptionValue.find( product_option_value_id)   # we don't actually need to load these from the DB just yet.  We might already have them attached to the line item
      # when it's a multi-select
      if  product_option_value_id.is_a?(Array)
        product_option_value_id.each do |p|
          ids << p unless p.empty?
        end
      else
        ids <<  product_option_value_id unless  product_option_value_id.empty?
      end
    end if params[:ad_hoc_option_values]
    ids
  end

  def ad_hoc_option_value_customizations
    if params[:ad_hoc_option_value_customizations].present?
      Array(params[:ad_hoc_option_value_customizations].to_unsafe_h).each_with_object([]) do |(id, value), memo|
        memo << { id.to_i => value['value'] } if value['value'].present?
      end
    end
  end
end
