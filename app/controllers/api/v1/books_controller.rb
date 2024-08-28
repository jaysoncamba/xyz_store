class Api::V1::BooksController < ApplicationController
  def show
    service = Services::Isbn::Finder.new(params[:id])
    book = service.get_book
    logger.debug(service.errors)
    if book.presence
      render json: BookSerializer.new(book, {params: {isbn_13: service.formatted_isbn13, isbn_10: service.formatted_isbn10}}).serializable_hash.to_json, status: 200
    else service.errors.any?
      status = service.isbn_format_error? ? 404 : 400
      render json: ErrorSerializer.new(service.errors&.first).serializable_hash.to_json, status:
    end
  end
end
