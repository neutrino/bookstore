# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    field :id, ID, null: false
    field :title, Types::StringType
    field :year_published, Types::IntegerType
    field :authors, String
    field :description, String
    field :genre, Types::StringType
    field :user, Types::ReferencesType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
