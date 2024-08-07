# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

books = JSON.parse(File.read(Rails.root.join("db/json_files/books.json")))["books"]
publishers = {}
authors = {}

books.each do |book_hash|
  book = Book.find_or_initialize_by(book_hash.except(*%w[authors publisher]))
  publisher = publishers[book_hash["publisher"]] ||= Publisher.find_or_create_by(name: book_hash["publisher"]) 
  book.publisher = publisher
  book_hash["authors"].each do |author_hash|
    author = authors[author_hash] ||= Author.find_or_create_by(author_hash)
    book.authors << author
  end
  book.save!
end