class BookSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :edition, :publication_year
  
  attribute :image_url do |book|
    image_path = book.image_url.presence ? book.image_url : "books/not_available"
    ActionController::Base.helpers.asset_path(image_path)
  end
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
