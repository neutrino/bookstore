module Mutations
  class DeleteBook < BaseMutation
    graphql_name "deleteBook"

    argument :id, Integer, required: true
    field :book, Types::BookType, null: true

    def resolve(id:)
      if context[:current_user].nil?
        return { errors: ["User not authenticated"] }
      end

      book = context[:current_user].books.find(id)
      unless book
        return { errors: ["Book not found or not authorised to delete this book"] }
      end

      if book.destroy
        { book: book, success: true }
      else
        { errors: book.errors.full_messages }
      end
    end
  end
end