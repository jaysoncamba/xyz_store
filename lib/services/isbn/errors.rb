module Services::Isbn::Errors
  class InvalidFormat < StandardError; end
  class Isbn10CheckDigitError < StandardError; end
  class Isbn13CheckDigitError < StandardError; end
end