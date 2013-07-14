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
    @analysis_request.enrolle_code = ''
    @analysis_request.product_code = ''
    @analysis_request.variety_code = ''
    @analysis_request.generated_at = ''
    
    assert @analysis_request.invalid?
    assert_equal 4, @analysis_request.errors.size

    [:enrolle_code, :product_code, :variety_code, :generated_at].each do |attr|
      assert_error_message(@analysis_request, attr)
    end
  end
    
  private

  def assert_error_message(obj, attr, error = :blank)
    assert_equal [error_message_from_model(obj, attr, error)], obj.errors[attr]
  end
end
