require "faraday"
require "koodeyo/sdk/version"
require "koodeyo/sdk/railtie"
require "koodeyo/sdk/mailer"
require "koodeyo/sdk/accounts"
require "koodeyo/sdk/meeting"

module Koodeyo
  module Sdk
    class Error < StandardError; end
    class ApiResponse < SimpleDelegator
      def initialize(response)
        super(response)
      end

      def to_json
        @parsed_json ||= JSON.parse(body)
      end
    end

    class << self
      # Default configs
      def defaults
        { scheme: "https", host: "koodeyo.com", version: "v1" }
      end

      # Read config from app/config/koodeyo.yml
      def configuration
        @configuration ||= defaults.merge(Rails.application.config_for(:koodeyo) || {}).deep_symbolize_keys
      rescue StandardError
        defaults.deep_symbolize_keys
      end
    end
  end
end
