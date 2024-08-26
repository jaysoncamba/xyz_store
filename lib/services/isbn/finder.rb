class Services::Isbn::Finder
  attr_accessor :isbn10, :isbn13, :errors
  def initialize(isbn)
    @isbn = isbn
    @errors = []
    convert_isbn_values
    @errors << { message: "Invalid ISBN FORMAT" } if [@isbn10, @isbn13].all?(&:nil?) && @errors.empty?
  end

  def get_book
    return nil if @errors.presence
    Book.find_by(isbn_13: @isbn13)
  end

  private

  def convert_isbn_values
    sanitized_isbn = @isbn.gsub(/[-\s]/, '')
    if valid_isbn13?
      @isbn13 = sanitized_isbn
      @isbn10 = convert_to_isbn_10
    elsif valid_isbn10?
      @isbn10 = sanitized_isbn
      @isbn13 = convert_to_isbn_13
    end
  end

  def convert_to_isbn_13
    return nil unless @isbn10.length == 10 && @isbn10.match?(/^\d{9}[\dX]$/)

    # Convert ISBN-10 to ISBN-13 by prefixing '978'
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

  def convert_to_isbn_10
    return nil unless @isbn13.length == 13 && @isbn13.match?(/^\d{13}$/)
    return nil unless @isbn13.start_with?('978')
    # Convert ISBN-13 to ISBN-10 by removing '978'
    isbn10_base = @isbn13[3..11]

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

  def valid_isbn13?
    # Validate ISBN-13 length and format
    sanitized_isbn = @isbn.gsub(/[-\s]/, '')
    return false unless sanitized_isbn.length == 13 && sanitized_isbn.match?(/^\d{13}$/)
    sum = 0
    sanitized_isbn.chars.each_with_index do |char, idx|
      next if idx == sanitized_isbn.length - 1 
      digit = char.to_i
      # each digit must be multiplied by 1 and 3 alternately
      sum += idx.even? ? digit : digit * 3
    end
    
    check_digit = sanitized_isbn[-1].to_i
    # Validate the check digit
    if (10 - (sum % 10)) % 10 == check_digit
      @isbn13 = sanitized_isbn
      true
    else
      @errors << { message: "invalid ISBN 13 check digit fail" }
      false
    end
  end

  def valid_isbn10?
    # Validate ISBN-10 length and format
    sanitized_isbn = @isbn.gsub(/[-\s]/, '')
    return false unless sanitized_isbn.length == 10 && sanitized_isbn.match?(/^\d{9}[\dX]$/)
    sum = 0
    sanitized_isbn.chars.each_with_index do |char, idx|
      next if idx == sanitized_isbn.length - 1
      digit = char.upcase == 'X' ? 10 : char.to_i
      sum += digit * (10 - idx)
    end

    expected_check_digit = sanitized_isbn[-1].upcase == "X" ? 10 : sanitized_isbn[-1].to_i 
    # ISBN-10 is valid if the sum is divisible by 11
    check_digit = (11 - (sum % 11)) % 11
    puts "valid_isbn10: check_digit: #{check_digit}, expected_check_digit: #{expected_check_digit}, sum: #{sum}"
    if expected_check_digit == check_digit
      @isbn10 = sanitized_isbn
      true
    else
      @errors << { message: "invalid ISBN 10 check digit fail" }
      false
    end
  end
end