class Api::V1::BooksController < ApplicationController
  def show
    service = Services::Isbn::Finder.new(params[:id])
    book = service.get_book
    logger.debug(service.errors)
    if book.presence
      render json: BookSerializer.new(book, {params: {isbn_13: service.isbn13, isbn_10: service.isbn10}}).serializable_hash.to_json
    else
      render json: {}
    end
  end
end
