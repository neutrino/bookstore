require "rails_helper"

RSpec.describe "mutation signIn", type: :request do
  it "authenticates the user and returns a user token" do
    user = create(:user)
    post "/graphql", params: {
      query: query(email: user.email, password: user.password)
    }

    result = JSON.parse(response.body)
    expect(result.dig("data", "signIn").present?).to be true
    expect(result.dig("data", "signIn", "success")).to be true
  end

  it "authenticates the user and returns a user token" do
    user = create(:user)
    post "/graphql", params: {
      query: query(email: user.email, password: "InvalidPassword")
    }

    result = JSON.parse(response.body)
    expect(result.dig("data", "signIn")).to be nil
    expect(result.dig("errors").present?).to be true
  end

  def query(email:, password:)
    <<~GQL
      mutation {
        signIn(input: {
          email: "#{email}",
          password: "#{password}"
        })
        {
          user {
            id
            email
          }
          success
          token
        }
      }
    GQL
  end
end
