class BookSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :image_url, :edition, :publication_year
  attribute :authors do |book|
    book.authors.map(&:name).join(', ')
  end
  attribute :publisher do |book|
    book.publisher.name
  end

  attribute :isbn_13 do |book, params|
    params[:isbn_13]
  end

  attribute :isbn_10 do |book, params|
    params[:isbn_10]
  end
end
