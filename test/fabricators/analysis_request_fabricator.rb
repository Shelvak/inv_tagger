Fabricator(:analysis_request) do
  enrolle_code    { '[A12345] The Crazy Man'  }
  product_code    { 0 }
  variety_code    { 0 }
  generated_at    { rand(9).days.ago }
end
