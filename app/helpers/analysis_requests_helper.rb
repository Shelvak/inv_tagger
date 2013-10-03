module AnalysisRequestsHelper
  def generated_at_picker(form)
    form.input :generated_at, as: :date_picker, input_html: { 
      value: l(form.object.try(:generated_at) || Date.today),
      class: 'span9'
    }
  end

  def enrolle_code_input(f)
    autocomplete_field_input(
      f, :related_enrolle, value: f.object.enrolle,
      path: inv_communications_enrolle_path(format: :json)
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
      f, :related_variety, value: f.object.variety, required: false,
      path: inv_communications_variety_path(format: :json)
    )
  end

  def destiny_code_input(f)
    f.input :related_destiny, label: false, input_html: {
      class: 'span10', autocomplete: 'off', data: {
        token_autocomplete: true,
        load: f.object.try(:destinies),
        path: inv_communications_destiny_path(format: :json),
        no_result: t('shared.no_result'),
        tokenized: false
      } 
    }
  end
end
