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

  def variety_codes_input(f)
    f.input :related_varieties, label: false, input_html: {
      class: 'span10', autocomplete: 'off', data: {
        token_autocomplete: true,
        load: f.object.try(:varieties),
        path: inv_communications_variety_path(format: :json),
        no_result: t('shared.no_result'),
        tokenized: false
      }
    }
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

  def request_type_for_analysis_request(form)
    selected = form.object.try(:request_type)

    collection = AnalysisRequest::REQUEST_TYPES.map do |k, v|
      selected ||= k if v == 'preferential'

      [t("view.analysis_requests.types.#{v}"), k]
    end

    form.input :request_type, collection: collection,
      selected: selected, include_blank: false, input_html: { class: 'span10' }
  end

  def depositary_enrolle_code_input(f)
    autocomplete_field_input(
      f, :related_depositary_enrolle, value: f.object.depositary_enrolle,
      path: inv_communications_enrolle_path(format: :json)
    )
  end

  def special_analysis_select_for_request(form)
    collection = [
      [t('label.no'), false],
      [t('label.yes'), true]
    ]

    form.input :special_analysis, collection: collection, prompt: false,
      selected: form.object.special_analysis, input_html: { class: 'span6' }
  end

  def tasting_select_for_request(form)
    collection = [
      [t('label.no'), false],
      [t('label.yes'), true]
    ]

    form.input :tasting, collection: collection, prompt: false,
      selected: form.object.tasting, input_html: { class: 'span6' }
  end
end
