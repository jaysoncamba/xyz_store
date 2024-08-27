require 'rails_helper'

RSpec.describe Services::Isbn::Converter do
  describe '.convert_to_isbn_13' do
    context 'when given a valid ISBN-10' do
      it 'converts a valid ISBN-10 to the correct ISBN-13' do
        isbn10 = '0-306-40615-2'
        expect(Services::Isbn::Converter.convert_to_isbn_13(isbn10)).to eq('9780306406157')
      end

      it 'returns nil for an invalid ISBN-10 format' do
        isbn10 = '0-306-4061X'
        expect(Services::Isbn::Converter.convert_to_isbn_13(isbn10)).to be_nil
      end
    end

    context 'when given an invalid ISBN-10' do
      it 'returns nil for an invalid ISBN-10' do
        isbn10 = '0-306-40615-3'
        expect(Services::Isbn::Converter.convert_to_isbn_13(isbn10)).to be_nil
      end
    end
  end

  describe '.convert_to_isbn_10' do
    context 'when given a valid ISBN-13' do
      it 'converts a valid ISBN-13 to the correct ISBN-10' do
        isbn13 = '978-0-306-40615-7'
        expect(Services::Isbn::Converter.convert_to_isbn_10(isbn13)).to eq('0306406152')
      end

      it 'returns nil for an invalid ISBN-13 format' do
        isbn13 = '978-0-306-4061X-7'
        expect(Services::Isbn::Converter.convert_to_isbn_10(isbn13)).to be_nil
      end
    end

    context 'when given an invalid ISBN-13' do
      it 'returns nil for an invalid ISBN-13' do
        isbn13 = '978-0-306-40615-8'
        expect(Services::Isbn::Converter.convert_to_isbn_10(isbn13)).to be_nil
      end
    end
  end
end