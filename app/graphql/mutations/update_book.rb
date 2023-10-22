module Mutations
  class UpdateBook < BaseMutation
    graphql_name "updateBook"
    argument :id, Integer, required: true
    argument :title, String, required: true
    argument :year_published, Integer, required: true
    argument :authors, String
    argument :description, String
    argument :genre, String, required: false

    field :book, Types::BookType, null: true

    def resolve(id:, title:, year_published:, authors:, description:, genre:)
      if context[:current_user].nil?
        return { errors: ["User not authenticated"] }
      end

      book = context[:current_user].books.find(id)
      unless book
        return { errors: ["Book not found or not authorised to update this book"] }
      end
      # book = Book.find(id)

      if book.update(
        title: title,
        year_published: year_published,
        authors: authors,
        description: description,
        genre: genre)
        { book: book, success: true }
      else
        # The book have the modified values which are not saved in the database.
        old_book = context[:current_user].books.find(id)
        { book: old_book, errors: book.errors.full_messages }
      end
    end
  end
end