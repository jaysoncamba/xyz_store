require 'rails_helper'

RSpec.describe Services::Isbn::Validator do
  describe '.valid_isbn13_format?' do
    it 'returns true for a valid ISBN-13 with 978 prefix and 13 digits' do
      expect(described_class.valid_isbn13_format?(' 978-3-16-148410-0')).to be true
    end

    it 'returns false for an ISBN-13 that does not start with 978' do
      expect(described_class.valid_isbn13_format?('979-3-16-148410-0')).to be false
    end

    it 'returns false for an ISBN-13 with incorrect length' do
      expect(described_class.valid_isbn13_format?('978-3-16-14841')).to be false
    end

    it 'returns false for an ISBN-13 with non-digit characters' do
      expect(described_class.valid_isbn13_format?('978-3-16-148410-X')).to be false
    end
  end

  describe '.valid_isbn10_format?' do
    it 'returns true for a valid ISBN-10' do
      expect(described_class.valid_isbn10_format?('0-306-40615-2')).to be true
    end

    it 'returns false for an ISBN-10 with non-digit and non-X characters' do
      expect(described_class.valid_isbn10_format?('0-306-40615-Y')).to be false
    end

    it 'returns false for an ISBN-10 with incorrect length' do
      expect(described_class.valid_isbn10_format?('0-306-4061')).to be false
    end
  end

  describe '.valid_isbn13?' do
    it 'returns true for a valid ISBN-13 with correct check digit' do
      expect(described_class.valid_isbn13?('978-0-306-40615-7')).to be true
    end

    it 'returns false for an invalid ISBN-13 with incorrect check digit' do
      expect(described_class.valid_isbn13?('978-0-306-40615-0')).to be false
    end

    it 'returns false for an invalid ISBN-13 format' do
      expect(described_class.valid_isbn13?('978-0-306-40615-')).to be false
    end
  end

  describe '.valid_isbn10?' do
    it 'returns true for a valid ISBN-10' do
      expect(described_class.valid_isbn10?('0-306-40615-2')).to be true
    end

    it 'returns false for an invalid ISBN-10 with incorrect check digit' do
      expect(described_class.valid_isbn10?('0-306-40615-1')).to be false
    end

    it 'returns true for an ISBN-10 where the check digit is X' do
      expect(described_class.valid_isbn10?('160309038X')).to be true
    end

    it 'returns false for an ISBN-10 with non-digit and non-X characters' do
      expect(described_class.valid_isbn10?('0-306-4061Y')).to be false
    end

    it 'returns false for an ISBN-10 with incorrect length' do
      expect(described_class.valid_isbn10?('0-306-4061')).to be false
    end

    it 'returns false for an ISBN-10 with invalid format' do
      expect(described_class.valid_isbn10?('0-306-4061')).to be false
    end

    it 'returns false for an ISBN-10 with invalid characters' do
      expect(described_class.valid_isbn10?('0-306-4061A')).to be false
    end

    it 'returns true for valid ISBN-10 with spaces' do
      expect(described_class.valid_isbn10?(' 0 306 40615 2 ')).to be true
    end

    it 'returns false for ISBN-10 with incorrect check digit due to spaces' do
      expect(described_class.valid_isbn10?(' 0 306 40615 1 ')).to be false
    end
  end
end