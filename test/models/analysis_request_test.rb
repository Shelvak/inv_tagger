require 'test_helper'

class AnalysisRequestTest < ActiveSupport::TestCase
  def setup
    @analysis_request = Fabricate(:analysis_request)
  end

  test 'create' do
    assert_difference ['AnalysisRequest.count', 'Version.count'] do
      @analysis_request = AnalysisRequest.create(Fabricate.attributes_for(:analysis_request))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'AnalysisRequest.count' do
        assert @analysis_request.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @analysis_request.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('AnalysisRequest.count', -1) { @analysis_request.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @analysis_request.attr = ''
    
    assert @analysis_request.invalid?
    assert_equal 1, @analysis_request.errors.size
    assert_equal [error_message_from_model(@analysis_request, :attr, :blank)],
      @analysis_request.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_analysis_request = Fabricate(:analysis_request)
    @analysis_request.attr = new_analysis_request.attr

    assert @analysis_request.invalid?
    assert_equal 1, @analysis_request.errors.size
    assert_equal [error_message_from_model(@analysis_request, :attr, :taken)],
      @analysis_request.errors[:attr]
  end
end
