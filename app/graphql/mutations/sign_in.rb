module Mutations
  class SignIn < BaseMutation
    graphql_name "signIn"

    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(email:, password:)
      user = User.authenticate(email, password)
      errors = {}

      if user
        context[:current_user] = user
        token = AuthToken.token(user)
        {token: AuthToken.token(user), user:, success: true}
      else
        user = nil
        context[:current_user] = nil
        raise GraphQL::ExecutionError, "Incorrect Email/Password"
      end
    end
  end
end