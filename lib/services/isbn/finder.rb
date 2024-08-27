class Services::Isbn::Finder
  attr_accessor :isbn10, :isbn13, :errors
  def initialize(isbn)
    @isbn = isbn
    @errors = []
    convert_isbn_values
  end

  def get_book
    return nil if @errors.presence
    Book.find_by(isbn_13: @isbn13)
  end

  private

  def convert_isbn_values
    if Services::Isbn::Validator.valid_isbn10_format?(@isbn)
      if Services::Isbn::Validator.valid_isbn10?(@isbn)
        @isbn10 = @isbn.gsub(/[^0-9X]/i, '')
        @isbn13 = Services::Isbn::Converter.convert_to_isbn_13(@isbn10)
      else
        @errors << { message: "ISBN 10 Check Digit Fails" }
      end
    elsif Services::Isbn::Validator.valid_isbn13_format?(@isbn)
      if Services::Isbn::Validator.valid_isbn13?(@isbn)
        @isbn13 = @isbn.gsub(/[-\s]/, '')
        @isbn10 = Services::Isbn::Converter.convert_to_isbn_10(@isbn13)
      else
        @errors << { message: "ISBN 13 Check Digit Fails" }
      end
    else
      @errors << { message: "Invalid ISBN FORMAT" }
    end
  end
end