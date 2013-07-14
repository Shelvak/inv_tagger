module AnalysisRequestsHelper
  def generated_at_picker(form)
    form.input :generated_at, as: :date_picker, input_html: { 
      value: l(form.object.try(:generated_at) || Date.today),
      class: 'span12'
    }
  end

  def enrolle_code_input(f)
    autocomplete_field_input(
      f, :related_product, value: f.object.product,
      path: inv_communications_product_path(format: :json)
    )
  end

  def product_code_input(f)
    autocomplete_field_input(
      f, :related_product, value: f.object.product,
      path: inv_communications_product_path(format: :json)
    )
  end

  def variety_code_input(f)
    autocomplete_field_input(
      f, :related_variety, value: f.object.variety,
      path: inv_communications_variety_path(format: :json)
    )
  end
end
