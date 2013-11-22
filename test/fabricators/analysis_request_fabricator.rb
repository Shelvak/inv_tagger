Fabricator(:analysis_request) do
  related_enrolle               { "[A00006] #{Faker::Name.name}"  }
  related_depositary_enrolle    { "[A00002] #{Faker::Name.name}"  }
  related_product               { "[7] #{Faker::Name.name}" }
  related_variety               { "[113] #{Faker::Name.name}" }
  generated_at                  { rand(9).days.ago }
  quantity                      { rand(999) }
  related_destiny               { "[900, 901, 902]" }
  harvest                       2005
  request_type                  { AnalysisRequest::REQUEST_TYPES.keys.sample }
end
