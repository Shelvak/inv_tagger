Fabricator(:analysis_request) do
  related_enrolle               { InvEnrolle.take.to_s }
  related_depositary_enrolle    { InvEnrolle.take.to_s }
  related_product               { InvProduct.take.to_s }
  related_varieties             { InvVariety.take.code.to_s }
  generated_at                  { rand(9).days.ago }
  quantity                      { rand(999) }
  related_destiny               { "[200, 201, 202]" }
  harvest                       2005
  request_type                  { AnalysisRequest::REQUEST_TYPES.keys.sample }
  special_analysis              { [true, false].sample }
  tasting                       { [true, false].sample }
  copies                        { rand(10) }
end
