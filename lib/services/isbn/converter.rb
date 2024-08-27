class Services::Isbn::Converter
  class << self
    def convert_to_isbn_13(isbn10)
      return nil unless Services::Isbn::Validator.valid_isbn10?(isbn10)

      # Convert ISBN-10 to ISBN-13 by prefixing '978'
      isbn10 = isbn10.gsub(/[^0-9X]/, '')  # Sanitize the input
      isbn13_base = "978" + isbn10[0..8]

      # Calculate the ISBN-13 check digit
      sum = 0
      isbn13_base.chars.each_with_index do |char, index|
        digit = char.to_i
        sum += (index.even? ? digit : digit * 3)
      end

      check_digit = (10 - (sum % 10)) % 10
      isbn13 = isbn13_base + check_digit.to_s
    end

    def convert_to_isbn_10(isbn13)
      return nil unless Services::Isbn::Validator.valid_isbn13?(isbn13)

      # Convert ISBN-13 to ISBN-10 by removing '978'
      isbn13 = isbn13.gsub(/[^0-9X]/, '')  # Sanitize the input
      isbn10_base = isbn13[3..11]

      # Calculate the ISBN-10 check digit
      sum = 0
      isbn10_base.chars.each_with_index do |char, index|
        digit = char.to_i
        sum += (10 - index) * digit
      end

      check_digit = (11 - (sum % 11)) % 11
      check_digit = check_digit == 10 ? 'X' : check_digit.to_s

      isbn10_base + check_digit
    end
  end
end