
require "rails_helper"

RSpec.describe "mutation deleteBook",  type: :request do

  let(:user) { create(:user) }
  let(:token) { AuthToken.token(user) }

  context "Valid token in the request header" do
    it "should have a valid token in the request header" do
      book = create(:book, user: user)

      post "/graphql",
        params: {
          query: query(book: book)
        },
        headers: {"Authorization" => "Bearer #{token}"}

      result = JSON.parse(response.body)
      expect(result["data"]["deleteBook"]["success"]).to be true
    end

    it "should have a valid token in the request header" do
      book = create(:book, user: user)

      post "/graphql",
        params: {
          query: query(book: book)
        },
        headers: {"Authorization" => "Bearer RANDOMTOKEN"}

      result = JSON.parse(response.body)
      expect(result["data"]["deleteBook"]["success"]).to be nil
      expect(result["data"]["deleteBook"]["errors"].present?).to be true
    end
  end

  it "deletes a book" do
    book = create(:book, user: user)

    post "/graphql",
      params: {
        query: query(book: book)
      },
      headers: {"Authorization" => "Bearer #{token}"}

    result = JSON.parse(response.body)
    expect(result["data"]["deleteBook"]["success"]).to be true
    expect(result["data"]["deleteBook"]["errors"]).to be nil
  end


  def query(book:)
    <<~GQL
      mutation {
      deleteBook(input: {
          id: #{book.id}
        })
        {
          book {
            id
            title
            yearPublished
            authors
            description
            user {
              id
              email
            }
          }
          success
          errors
        }
      }
    GQL
  end
end
