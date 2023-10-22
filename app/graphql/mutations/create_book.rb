module Mutations
  class CreateBook < BaseMutation
    graphql_name "createBook"

    argument :title, String, required: true
    argument :year_published, Integer, required: true
    argument :authors, String
    argument :description, String
    argument :genre, String, required: false
    field :book, Types::BookType, null: true

    def resolve(title:, year_published:, authors:, description:, genre:)
      if context[:current_user].nil?
        return { errors: ["User not authenticated"] }
      end
      if context[:current_user]
        book = context[:current_user].books.build(
          title: title,
          year_published: year_published,
          authors: authors,
          description: description,
          genre: genre)
        if book.save
          { book: book, success: true}
        else
          { errors: book.errors.full_messages }
        end
      else
        { errors: ["User not found"] }
      end
    end
  end
end