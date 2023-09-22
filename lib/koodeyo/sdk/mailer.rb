
module Koodeyo
  module Sdk
    # Provides a delivery method for ActionMailer that uses Koodeyo email Service.
    # Configure Rails to use this for ActionMailer in your environment configuration
    # (e.g. RAILS_ROOT/config/environments/production.rb)
    # config.action_mailer.delivery_method = :koodeyo

    class Mailer
      def initialize(options = {})
        options[:headers] ||= mailer_config[:headers] || {}
        options[:host] ||= endpoint

        @connection = Faraday.new(
          url: options[:host],
          headers: options[:headers].merge({
            'Content-Type': 'application/json'
          })
        ) do |f|
          f.request :json
          f.response :json
        end
      end

      # Rails expects this method to exist, and to handle a Mail::Message object
      # correctly. Called during mail delivery.
      def deliver!(message)
        params = { raw: message.to_s }

        # smtp_envelope_from will default to the From address *without* sender names.
        # By omitting this param, this will correctly use sender names from the mail headers.
        # We should only use smtp_envelope_from when it was explicitly set (instance variable set)
        params[:from_email_address] = message.smtp_envelope_from if message.instance_variable_get(:@smtp_envelope_from)
        params[:destination] = {
          to_addresses: to_addresses(message),
          cc_addresses: message.cc,
          bcc_addresses: message.bcc
        }

        send_email(params)
      end

      # ActionMailer expects this method to be present and to return a hash.
      def settings
        {}
      end

      private

      def mailer_config
        Sdk.configuration[:mailer] || {}
      end

      def endpoint
        @endpoint ||= mailer_config[:host] || default_mailer_url
      end

      def default_mailer_url
        "#{Sdk.configuration[:scheme] || "http"}://mailer.#{Sdk.configuration[:host]}/api/#{Sdk.configuration[:version]}"
      end

      def send_email(payload)
        response = @connection.post("delivery") do |req|
          req.body = { delivery: payload }
        end

        ApiResponse.new(response)
      end

      def to_addresses(message)
        message.instance_variable_get(:@smtp_envelope_to) ? message.smtp_envelope_to : message.to
      end
    end
  end
end
