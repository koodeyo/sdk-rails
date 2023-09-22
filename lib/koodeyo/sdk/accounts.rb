module Koodeyo
  module Sdk
    class Accounts
      def initialize(options = {})
        options[:headers] ||= accounts_config[:headers] || {}
        options[:host] ||= endpoint
        @options = options
      end

      def get_access_token
        response = auth_connection.post do |request|
          request.url '/oauth/token'
          request.body = Sdk.configuration[:authorization] || {}
        end

        ApiResponse.new(response)
      end

      def validate_api_key(token)
        response = connection.post do |request|
          request.url "utils/api_keys/validate"
          request.body = JSON.dump({ api_key: token })
        end

        ApiResponse.new(response)
      end

      private

      def endpoint
        accounts_config[:host] || "#{Sdk.configuration[:scheme] || "http"}://accounts.#{Sdk.configuration[:host]}/api/#{Sdk.configuration[:version]}"
      end

      def connection
        @connection ||= Faraday.new(
          url: @options[:host],
          headers: @options[:headers].merge({
            "Content-Type": "application/json",
            "Authorization": "Bearer #{get_access_token.to_json["access_token"]}",
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
