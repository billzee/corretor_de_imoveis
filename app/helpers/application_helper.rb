module ApplicationHelper

  def property_description p
    "#{I18n.t "views.#{p.type}.one"} #{p.title} localizado no endereço #{p.address} para #{I18n.t "views.deal.#{p.deal}"}"
  end

  def generate_title params
    return I18n.t "views.#{params[:type]}.other" if params[:type]
    return "Empreendimentos" if params[:filter] && params[:filter][:is_enterprise]
    return "Imóveis"
  end

  def s3_assets_path file
    "#{ENV['S3_URL']}/assets/#{file}"
  end

  def unread_customer_properties_badge
    total = CustomerProperty.unread_count
    render "partials/badge", total: total if total > 0
  end

  def prev_page
    request.referer || root_path
  end

  def has_extras? property
    property.extra_list && property.extra_list.list.length > 0
  end

  def has_gallery? property
    property.gallery && property.gallery.images.length > 0
  end

  def square_meters value
    "#{number_with_precision(value, precision: 2)} m²"
  end

  def pluralize(size, singular, plural)
    if size == 1 then "#{size} #{singular}" else "#{size} #{plural}" end
  end

  def generate_breadcrumbs filter
    first_crumb = I18n.t "views.#{property_type}.other"

    if filter
      if filter.keys[0] == "number_of_rooms" && property_name == "house"
        rooms = filter.values[0].to_i
        if rooms == 4
          qtd = pluralize filter.values[0].to_i, "quarto", "quartos"
          second_crumb = "#{qtd} ou mais"
        else
          second_crumb = pluralize filter.values[0].to_i, "quarto", "quartos"
        end
      else
        first_crumb = "Imóveis" if filter.keys[0] == "is_enterprise"
        second_crumb = I18n.t "views.#{filter.keys[0]}.#{filter.values[0]}"
      end

      @listing_title = "Vendas / #{first_crumb} / #{second_crumb}"
    else
      @listing_title = "Vendas / #{first_crumb}" if property_type
      @listing_title ||= "Vendas"
    end
  end

  def error_message_for_field(object, field_name)
    if !object.nil?
      if object.errors.any?
        if !object.errors.messages[field_name].blank?
          render "partials/error_message_for_field",
          message: object.errors.messages[field_name].first
        end
      end
    end
  end

  def validate_field(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
        return "is-invalid"
      end
    end
    return ""
  end

end
