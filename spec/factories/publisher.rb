FactoryBot.define do
  factory :publisher do
    name { FFaker::Name.unique.name }
  end
end