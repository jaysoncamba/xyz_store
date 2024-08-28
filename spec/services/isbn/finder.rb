require 'rails_helper'

RSpec.describe Services::Isbn::Finder do
  let(:book) { FactoryBot.build(:book)  }
  
  describe '#initialize' do
    context 'when provided with a valid ISBN-10' do
      it 'converts ISBN-10 to ISBN-13 and does not have errors' do
        isbn10 = '0306406152'
        valid_isbn13 = '9780306406157'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn10_format?).with(isbn10).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_13).with(isbn10).and_return(valid_isbn13)
        
        finder = Services::Isbn::Finder.new(isbn10)
        
        expect(finder.isbn10).to eq('0306406152')
        expect(finder.isbn13).to eq('9780306406157')
        expect(finder.errors).to be_empty
      end
    end

    context 'when provided with an invalid ISBN-10 format' do
      it 'adds an error for invalid format' do
        isbn10 = '030640615X'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn10_format?).with(isbn10).and_return(false)
        
        finder = Services::Isbn::Finder.new(isbn10)
        
        expect(finder.errors).to include({ message: 'Invalid ISBN' })
      end
    end

    context 'when provided with a valid ISBN-13' do
      it 'converts ISBN-13 to ISBN-10 and does not have errors' do
        isbn13 = '9780306406157'
        valid_isbn10 = '0306406152'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn13).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_10).with(isbn13).and_return(valid_isbn10)
        
        finder = Services::Isbn::Finder.new(isbn13)
        
        expect(finder.isbn13).to eq('9780306406157')
        expect(finder.isbn10).to eq('0306406152')
        expect(finder.errors).to be_empty
      end
    end

    context 'when provided with an invalid ISBN-13 format' do
      it 'adds an error for invalid format' do
        isbn13 = '978030640615X'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn13).and_return(false)
        
        finder = Services::Isbn::Finder.new(isbn13)
        
        expect(finder.errors).to include({ message: 'Invalid ISBN' })
      end
    end

    context 'when ISBN-10 check digit fails' do
      it 'adds an error for ISBN-10 check digit failure' do
        isbn10 = '0306406151'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn10_format?).with(isbn10).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_13).with(isbn10).and_return(nil)
        
        finder = Services::Isbn::Finder.new(isbn10)
        
        expect(finder.errors).to include({ message: 'ISBN 10 Check Digit Fails' })
      end
    end

    context 'when ISBN-13 check digit fails' do
      it 'adds an error for ISBN-13 check digit failure' do
        isbn13 = '9780306406158'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn13).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_10).with(isbn13).and_return(nil)
        
        finder = Services::Isbn::Finder.new(isbn13)
        
        expect(finder.errors).to include({ message: 'ISBN 13 Check Digit Fails' })
      end
    end

    context 'when ISBN format is completely invalid' do
      it 'adds an error for invalid format' do
        isbn = '123456789'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn10_format?).with(isbn).and_return(false)
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn).and_return(false)
        
        finder = Services::Isbn::Finder.new(isbn)
        
        expect(finder.errors).to include({ message: 'Invalid ISBN' })
      end
    end

    context 'when ISBN contains special characters' do
      it 'normalizes the ISBN and processes it correctly' do
        isbn10 = '0306406152'
        valid_isbn13 = '9780306406157'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn10_format?).with(isbn10.gsub(/[^0-9X]/i, '')).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_13).with('0306406152').and_return(valid_isbn13)
        
        finder = Services::Isbn::Finder.new(isbn10)
        
        expect(finder.isbn10).to eq('0306406152')
        expect(finder.isbn13).to eq('9780306406157')
        expect(finder.errors).to be_empty
      end
    end
  end

  describe '#get_book' do
    context 'when no errors' do
      it 'finds the book by ISBN-13' do
        isbn13 = '9780306406157'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn13).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_10).with(isbn13).and_return('0-306-40615-2')
        allow(Book).to receive(:find_by).with(isbn_13: '9780306406157').and_return(book)
        
        finder = Services::Isbn::Finder.new(isbn13)
        
        expect(finder.get_book).to eq(book)
      end
    end

    context 'when there are errors' do
      it 'returns nil' do
        isbn13 = '9780306406158'
        
        allow(Services::Isbn::Validator).to receive(:valid_isbn13_format?).with(isbn13).and_return(true)
        allow(Services::Isbn::Converter).to receive(:convert_to_isbn_10).with(isbn13).and_return(nil)
        
        finder = Services::Isbn::Finder.new(isbn13)
        
        expect(finder.get_book).to be_nil
      end
    end
  end
end