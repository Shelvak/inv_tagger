require 'test_helper'

class AnalysisRequestTest < ActiveSupport::TestCase
  def setup
    @analysis_request = Fabricate(:analysis_request)
  end

  test 'create' do
    assert_difference 'AnalysisRequest.count' do
      AnalysisRequest.create!(Fabricate.attributes_for(:analysis_request))
    end 
  end

  test 'validates blank attributes' do
    @analysis_request.related_enrolle = ''
    @analysis_request.related_product = ''
    @analysis_request.related_variety = ''
    @analysis_request.generated_at = ''
    @analysis_request.quantity = ''
    @analysis_request.harvest = ''
    @analysis_request.related_destiny = ''
    
    assert @analysis_request.invalid?
    assert_equal 7, @analysis_request.errors.size

    [
      :related_enrolle, :related_product, :related_variety, :generated_at,
      :quantity, :related_destiny, :harvest
    ].each do |attr|
      assert_error_message(@analysis_request, attr)
    end
  end
    
  private

  def assert_error_message(obj, attr, error = :blank)
    assert_equal [error_message_from_model(obj, attr, error)], obj.errors[attr]
  end
end
