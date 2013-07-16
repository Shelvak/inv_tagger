Fabricator(:analysis_request) do
  related_enrolle     { "[A#{rand(999)}] #{Faker::Name.name}"  }
  related_product     { "[#{rand(999)}] #{Faker::Name.name}" }
  related_variety     { "[#{rand(999)}] #{Faker::Name.name}" }
  generated_at        { rand(9).days.ago }
  quantity            { rand(999) }
  related_destiny     { "[#{rand(999)}] #{Faker::Address.country}" }
  harvest             2005
end
