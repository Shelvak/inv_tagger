Fabricator(:analysis_request) do
  enrolle         { 0 }
  product         { 0 }
  variety         { 0 }
  generated_at    { rand(9).days.ago }
end
