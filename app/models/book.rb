class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :authors, :isbn_13, :price, :publication_year, :publisher, :title, { presence: true }
end
