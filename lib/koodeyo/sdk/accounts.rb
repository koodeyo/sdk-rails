module Koodeyo
  module Sdk
    class Accounts
      def initialize(options = {})
        options[:headers] ||= accounts_config[:headers] || {}
        options[:host] ||= endpoint
        @options = options
        @token_expiry_time = nil
        @cached_token = nil
      end

      def get_access_token
        if token_expired?
          response = auth_connection.post do |request|
            request.url '/oauth/token'
            request.body = (@options[:authorization] || Sdk.configuration[:authorization] || {})
          end

          api_response = ApiResponse.new(response)
          # Assuming the expires_in value is in seconds, calculate the exact time the token will expire.
          @token_expiry_time = Time.now.to_i + api_response.to_json["expires_in"].to_i
          @cached_token = api_response
        end
        @cached_token
      end

      def validate_api_key(token)
        response = connection.post do |request|
          request.url "utils/api_keys/validate"
          request.body = JSON.dump({ api_key: token })
        end

        ApiResponse.new(response)
      end

      def get_service
        response = connection.post do |request|
          request.url "utils/api_keys/validate"
          request.body = JSON.dump({ api_key: token })
        end

        ApiResponse.new(response)
      end

      def find_app_by_uid
        response = connection.get("applications/find_by_uid")
        ApiResponse.new(response)
      end

      private

      def token_expired?
        @token_expiry_time.nil? || Time.now.to_i >= @token_expiry_time
      end

      def endpoint
        accounts_config[:host] || "#{Sdk.configuration[:scheme] || "http"}://accounts.#{Sdk.configuration[:host]}/api/#{Sdk.configuration[:version]}"
      end

      def connection
        @connection ||= Faraday.new(
          url: @options[:host],
          headers: @options[:headers].merge({
            "Content-Type": "application/json",
            "Authorization": "Bearer #{get_access_token.to_json["access_token"]}"
          })
        )
      end

      def auth_connection
        @auth_connection ||= Faraday.new(url: endpoint)
      end

      def accounts_config
        @config ||= Sdk.configuration[:accounts] || {}
      end
    end
  end
end
