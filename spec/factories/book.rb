FactoryBot.define do
  factory :book do
    publisher
    title { FFaker::Book.title }
    isbn_13 { FFaker::Book.isbn }
    price { 2000 }
    publication_year { 2023 }
    authors { create_list(:author, 1)}
  end
end