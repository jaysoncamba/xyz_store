class Services::Isbn::Validator
  class << self
    def valid_isbn13_format?(isbn)
      # Validate ISBN-13 length and format
      return false unless isbn.start_with?('978')
      sanitized_isbn = isbn.gsub(/[-\s]/i, '')
      sanitized_isbn.length == 13 && sanitized_isbn.match?(/^\d{13}$/)
    end

    def valid_isbn10_format?(isbn)
      sanitized_isbn = isbn.gsub(/[^0-9X]/i, '')
      sanitized_isbn.length == 10 && sanitized_isbn.match?(/^\d{9}[\dX]$/)
    end

    def valid_isbn13?(isbn)
      return false unless valid_isbn13_format?(isbn)
      sanitized_isbn = isbn.gsub(/[-\s]/, '')

      sum = 0
      sanitized_isbn.chars.each_with_index do |char, idx|
        next if idx == sanitized_isbn.length - 1
        digit = char.to_i
        sum += idx.even? ? digit : digit * 3
      end

      check_digit = sanitized_isbn[-1].to_i
      (10 - (sum % 10)) % 10 == check_digit
    end
  
    def valid_isbn10?(isbn)
      sanitized_isbn = isbn.gsub(/[^0-9X]/i, '').upcase

      return false unless valid_isbn10_format?(isbn)

      sum = 0
      # Calculate the checksum excluding the last character (check digit)
      sanitized_isbn.chars.each_with_index do |char, idx|
        next if idx == sanitized_isbn.length - 1  # Skip the last character, which is the check digit
        digit = char.to_i
        weight = 10 - idx
        sum += digit * weight
      end

      # Determine the expected check digit
      check_digit = sanitized_isbn[-1]
      expected_check_digit = (11 - (sum % 11)) % 11
      expected_check_digit = 10 if expected_check_digit == 10

      # Check if the expected check digit matches the actual check digit
      (check_digit == 'X' && expected_check_digit == 10) || (check_digit.to_i == expected_check_digit)
    end
  end
end