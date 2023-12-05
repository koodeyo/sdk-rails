module Koodeyo
  module Sdk
    class Meeting
      def initialize(options = {})
        options[:headers] ||= meeting_config[:headers] || {}
        options[:host] ||= endpoint
        @options = options
      end

      def create(params)
        response = connection.post do |request|
          request.url "meetings/by_service_account"
          request.body = JSON.dump({ meeting: params })
        end

        ApiResponse.new(response)
      end

      def get(meetingId)
        response = connection.get("meetings/#{meetingId}")
        ApiResponse.new(response)
      end

      private

      def endpoint
        meeting_config[:host] || "#{Sdk.configuration[:scheme] || "http"}://meeting.#{Sdk.configuration[:host]}/api/#{Sdk.configuration[:version]}"
      end

      def connection
        @connection ||= Faraday.new(
          url: @options[:host],
          headers: @options[:headers].merge({
            "Content-Type": "application/json"
          })
        )
      end

      def meeting_config
        @config ||= Sdk.configuration[:meeting] || {}
      end
    end
  end
end
