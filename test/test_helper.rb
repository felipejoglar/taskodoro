ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    def sign_in_as(name: "User Name", email:, password:)
      user = create_user_with(name, email, password)
      post sign_in_path, params: login_params(email: user.email, password: user.password)

      user
    end

    private

    def create_user_with(name, email, password)
      User.create!(
        name: name,
        email: email,
        password: password,
        password_confirmation: password
      )
    end

    def login_params(email:, password:)
      {
        user:
          {
            email: email,
            password: password
          }
      }
    end
  end
end
