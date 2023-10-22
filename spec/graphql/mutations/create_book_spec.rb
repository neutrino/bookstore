
require "rails_helper"

RSpec.describe "mutation createBook",  type: :request do
  let(:user) { create(:user) }
  let(:book_attributes) { attributes_for(:book) }
  let(:token) { AuthToken.token(user) }

  context "Valid token in the request header" do
    it "should have a valid token in the request header" do
      post "/graphql",
        params: {
          query: query(book_attributes: book_attributes)
        },
        headers: {"Authorization" => "Bearer #{token}"}

      result = JSON.parse(response.body)
      expect(result["data"]["createBook"]["success"]).to be true
    end

    it "should have a valid token in the request header" do
      post "/graphql",
        params: {
          query: query(book_attributes: book_attributes)
        },
        headers: {"Authorization" => "Bearer RANDOMTOKEN"}

      result = JSON.parse(response.body)
      expect(result["data"]["createBook"]["success"]).to be nil
      expect(result["data"]["createBook"]["errors"].present?).to be true
    end
  end

  it "creates a book for valid attributes" do
    post "/graphql",
      params: {
        query: query(book_attributes: book_attributes)
      },
      headers: {"Authorization" => "Bearer #{token}"}

    result = JSON.parse(response.body)
    expect(result["data"]["createBook"]["success"]).to be true
    expect(result["data"]["createBook"]["errors"]).to be nil
    expect(result["data"]["createBook"]["book"]["title"]).to eq book_attributes[:title]
    # year_published -> yearPublished
    expect(result["data"]["createBook"]["book"]["yearPublished"]).to eq book_attributes[:year_published]
  end

  it "results error for a book with invalid attributes" do
    book_attributes[:year_published] = "1300"

    post "/graphql",
      params: {
        query: query(book_attributes: book_attributes)
      },
      headers: {"Authorization" => "Bearer #{token}"}

    result = JSON.parse(response.body)
    expect(result["data"]["createBook"]["success"]).to be nil
    expect(result["data"]["createBook"]["errors"].present?).to be true
  end


  def query(book_attributes:)
    <<~GQL
      mutation {
      createBook(input: {
          title: "#{book_attributes[:title]}",
          yearPublished: #{book_attributes[:year_published]},
          authors: "#{book_attributes[:authors]}",
          description: "#{book_attributes[:describe]}",
          genre: "#{book_attributes[:genre]}",
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
