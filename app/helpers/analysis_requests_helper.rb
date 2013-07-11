module AnalysisRequestsHelper

  def generated_at_picker(form)
    form.input :generated_at, as: :date_picker, input_html: { 
      value: f.object.try(:generated_at) || l(Date.today)
    }
  end
end
