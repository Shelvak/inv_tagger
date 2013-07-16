Fabricator(:analysis_request) do
  related_enrolle     { "[A#{rand(999)}] #{Faker::Name.name}"  }
  related_product     { "[#{rand(999)}] #{Faker::Name.name}" }
  related_variety     { "[#{rand(999)}] #{Faker::Name.name}" }
  generated_at        { rand(9).days.ago }
  quantity            { rand(999) }
end
