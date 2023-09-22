require "test_helper"

module Koodeyo
  module Sdk
    module Api
      class AccountsTest < ActiveSupport::TestCase
        def setup
          @api = Koodeyo::Sdk::Accounts.new
        end

        test "should get access_token" do
          response = @api.get_access_token
          assert response.success?

          # Some basic checks to ensure the response looks correct
          result = response.to_json
          assert_not_nil result["access_token"]
          assert_equal "Bearer", result["token_type"]
          assert result["expires_in"].is_a?(Numeric)
          assert result["created_at"].is_a?(Numeric)
        end

        test "should validate api-key" do
          # response = @api.validate_api_key("tkn_usr_fe7FznR6vUEJ1hMp7xFRbXqN5PgK4z")
          # assert response.success?
          # result = response.to_json
          # assert result["valid"]
          # assert_not_nil result["bearer"]
        end
      end
    end
  end
end
