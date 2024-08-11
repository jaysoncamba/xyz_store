class BookSerializer
  include JSONAPI::Serializer
  attributes :title, :isbn_13, :isbn_10, :price, :image_url, :edition, :publication_year
  attribute :authors do |book|
    book.authors.map(&:name).join(', ')
  end
  attribute :publisher do |book|
    book.publisher.name
  end
end
