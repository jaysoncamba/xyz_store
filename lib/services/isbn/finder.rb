class Services::Isbn::Finder
  attr_reader :isbn10, :isbn13, :errors
  def initialize(isbn)
    @isbn = isbn
    @errors = []
    convert_isbn_values
  end

  def get_book
    return nil if @errors.presence
    Book.find_by(isbn_13: @isbn13)
  end
  
  def formatted_isbn13
    @formatted_isbn13 ||=
      "#{@isbn13[0..2]}-#{@isbn13[3..4]}-#{@isbn13[5..8]}-#{@isbn13[9..11]}-#{@isbn13[12]}"
  end

  def formatted_isbn10
    @formatted_isbn10 ||=
      "#{@isbn10[0..2]}-#{@isbn10[3]}-#{@isbn10[4..7]}-#{@isbn10[8..9]}"
  end

  private

  def convert_isbn_values
    if Services::Isbn::Validator.valid_isbn10_format?(@isbn)
      @isbn10 = @isbn.gsub(/[^0-9X]/i, '')
      @isbn13 = Services::Isbn::Converter.convert_to_isbn_13(@isbn10) 
      @errors << { message: "ISBN 10 Check Digit Fails" } unless @isbn13
    elsif Services::Isbn::Validator.valid_isbn13_format?(@isbn)
      @isbn13 = @isbn.gsub(/[-\s]/, '')
      @isbn10 = Services::Isbn::Converter.convert_to_isbn_10(@isbn13)
      @errors << { message: "ISBN 13 Check Digit Fails" } unless @isbn10
    else
      @errors << { message: "Invalid ISBN FORMAT" }
    end
  end
end