class Author < ApplicationRecord
  validates :first_name, :last_name, { presence: true }

  has_many :book_authors
  has_many :books, through: :book_authors

  def name
    result = [first_name]
    result << "#{middle_name}." if middle_name.presence
    result << last_name
    result.join(" ")
  end
end
