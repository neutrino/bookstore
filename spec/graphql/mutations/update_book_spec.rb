
require "rails_helper"

RSpec.describe "mutation updateBook",  type: :request do

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
      expect(result["data"]["updateBook"]["success"]).to be true
    end

    it "should have a valid token in the request header" do
      book = create(:book, user: user)

      post "/graphql",
        params: {
          query: query(book: book)
        },
        headers: {"Authorization" => "Bearer RANDOMTOKEN"}

      result = JSON.parse(response.body)
      expect(result["data"]["updateBook"]["success"]).to be nil
      expect(result["data"]["updateBook"]["errors"].present?).to be true
    end
  end

  it "updates a book for valid attributes" do
    book = create(:book, user: user)
    old_book_title = book.title
    new_book_title = "New Book Title"
    book.title = new_book_title

    post "/graphql",
      params: {
        query: query(book: book)
      },
      headers: {"Authorization" => "Bearer #{token}"}

    result = JSON.parse(response.body)
    expect(result["data"]["updateBook"]["success"]).to be true
    expect(result["data"]["updateBook"]["errors"]).to be nil
    expect(result["data"]["updateBook"]["book"]["title"]).to eq new_book_title
    # year_published -> yearPublished
    expect(result["data"]["updateBook"]["book"]["yearPublished"]).to eq book[:year_published]
  end

  it "results error for a book with invalid attributes" do
    book = create(:book, user: user)
    old_year_published = book.year_published
    new_year_published = "1300"
    book.year_published = new_year_published

    post "/graphql",
      params: {
        query: query(book: book)
      },
      headers: {"Authorization" => "Bearer #{token}"}

    result = JSON.parse(response.body)
    expect(result["data"]["updateBook"]["success"]).to be nil
    expect(result["data"]["updateBook"]["errors"].present?).to be true
    expect(result["data"]["updateBook"]["book"]["yearPublished"]).to eq old_year_published
  end


  def query(book:)
    <<~GQL
      mutation {
        updateBook(input: {
            id: #{book.id}
            title: "#{book.title}",
            yearPublished: #{book.year_published},
            authors: "#{book.authors}",
            description: "#{book.description}",
            genre: "#{book.genre}",
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
