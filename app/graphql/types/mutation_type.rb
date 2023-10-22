# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_in, mutation: Mutations::SignIn
    field :createBook, mutation: Mutations::CreateBook
    field :updateBook, mutation: Mutations::UpdateBook
    field :deleteBook, mutation: Mutations::DeleteBook
  end
end
