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
    @analysis_request.related_destiny = ''
    @analysis_request.enrolle_code = ''
    @analysis_request.product_code = ''
    @analysis_request.destiny_codes = ''
    @analysis_request.generated_at = ''
    @analysis_request.quantity = ''
    @analysis_request.harvest = ''
    @analysis_request.related_depositary_enrolle = ''
    @analysis_request.depositary_enrolle_code = ''

    assert @analysis_request.invalid?
    assert_equal 7, @analysis_request.errors.size

    [
      :related_enrolle, :related_product, :generated_at,
      :quantity, :related_destiny, :harvest, :related_depositary_enrolle
    ].each do |attr|
      assert_error_message(@analysis_request, attr)
    end
  end

  test 'validates correct range of attributes' do
    @analysis_request.harvest = 1200
    assert @analysis_request.invalid?
    assert_equal 1, @analysis_request.errors.count
    assert_error_message(
      @analysis_request, :harvest, :greater_than_or_equal_to, count: 1500
    )

    @analysis_request.harvest = 2200
    assert @analysis_request.invalid?
    assert_equal 1, @analysis_request.errors.count
    assert_error_message(
      @analysis_request, :harvest, :less_than_or_equal_to, count: Date.today.year
    )
  end

  private

  def assert_error_message(obj, attr, error = :blank, opts={})
    assert_equal [error_message_from_model(obj, attr, error, opts)].sort,
      obj.errors[attr].sort
  end
end
