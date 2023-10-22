# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :success, Boolean
    field :errors, [String]

    field :books, [Types::BookType], null: false do
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 10
    end

    def books(page:, per_page:)
      Book.paginate(page: page, per_page: per_page)
    end

    field :book, Types::BookType, null: false do
      argument :id, Integer, required: true
    end

    def book(id:)
      Book.find(id)
      rescue ActiveRecord::RecordNotFound => error
        raise GraphQL::ExecutionError, error.message
    end
  end
end
