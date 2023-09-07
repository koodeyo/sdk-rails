require "test_helper"

module Koodeyo
  module Sdk
    class TestMailer < ActionMailer::Base
      layout nil

      def deliverable(options = {})
        headers(options.delete(:headers))
        mail(options)
      end
    end

    class MailerTest < ActiveSupport::TestCase
      def setup
        @client_options = {}

        @mailer = Mailer.new(@client_options)
        Koodeyo::Sdk.add_action_mailer_delivery_method(:koodeyo, @client_options)
      end

      def sample_message
        TestMailer.deliverable(
          delivery_method: :koodeyo,
          body: 'Hallo',
          from: 'Sender <sender@example.com>',
          subject: 'This is a test',
          to: 'Recipient <recipient@example.com>',
          cc: 'Recipient CC <recipient_cc@example.com>',
          bcc: 'Recipient BCC <recipient_bcc@example.com>',
          headers: {
            'X-SERVICE-ID' => '12'
          }
        )
      end

      test "should deliver the message" do
        code = @mailer.deliver!(sample_message)
        assert_equal(200, code)
      end
    end
  end
end
