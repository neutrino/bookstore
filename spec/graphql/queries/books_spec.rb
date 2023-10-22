
require "rails_helper"

RSpec.describe "query books",  type: :request do
  context "with page and per_page options" do
    it "returns  list of books" do
      create_list(:book, 6)
      post "/graphql",
        params: {
          query: query(page: 1, per_page: 5)
        }

      result = JSON.parse(response.body)
      expect(result["data"]["books"].present?).to be true
      expect(result["data"]["books"].size).to be 5
      expect(result["errors"]).to be nil
    end

    it "returns remaining books for second page" do
      create_list(:book, 6)
      post "/graphql",
        params: {
          query: query(page: 2, per_page: 5)
        }
      result = JSON.parse(response.body)
      expect(result["data"]["books"].present?).to be true
      expect(result["data"]["books"].size).to be 1
      expect(result["errors"]).to be nil
    end
  end

  def query(page:, per_page:)
    <<~GQL
      query {
        books(page: #{page}, perPage: #{per_page}) {
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
