
require "rails_helper"

RSpec.describe "query books",  type: :request do
  let(:book) { create(:book) }

  it "returns a book for valid id" do
    post "/graphql",
      params: {
        query: query(book_id: book.id)
      }

    result = JSON.parse(response.body)
    expect(result["data"]["book"].present?).to be true
    expect(result["data"]["book"]["id"]).to eq book.id.to_s
    expect(result["data"]["book"]["title"]).to eq book.title
    expect(result["errors"]).to be nil
  end

  it "returns remaining books for second page" do
    post "/graphql",
      params: {
        query: query(book_id: book.id + 5)
      }
    result = JSON.parse(response.body)
    expect(result["data"]).to be nil
    expect(result["errors"].present?).to be true
  end


  def query(book_id:)
    <<~GQL
      query {
        book(id: #{book_id}){
          id
          title
          yearPublished
          authors
          description
          genre
          user {
            id
            email
          }
        }
      }
    GQL
  end
end
