FactoryBot.define do
  factory :author do
    first_name { FFaker::Name.unique.first_name }
    last_name { FFaker::Name.unique.last_name }
  end
end