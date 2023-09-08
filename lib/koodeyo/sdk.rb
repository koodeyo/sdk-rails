require "koodeyo/sdk/version"
require "koodeyo/sdk/railtie"
require "koodeyo/sdk/mailer"

module Koodeyo
  module Sdk
    class Error < StandardError; end

    class << self
      # Default configs
      def defaults
        { scheme: "https", endpoint: "koodeyo.com", api_version: "v1" }
      end

      # Read config from app/config/koodeyo.yml
      def configuration
        defaults
          .merge(Rails.application.config_for(:koodeyo) || {})
          .deep_symbolize_keys
      rescue StandardError
        defaults.deep_symbolize_keys
      end
    end
  end
end
