class Author < ApplicationRecord
  validates :first_name, :last_name, { presence: true }

  has_many :book_authors
  has_many :books, through: :book_authors
end
