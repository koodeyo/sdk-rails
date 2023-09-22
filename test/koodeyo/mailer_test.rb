require "test_helper"

module Koodeyo
  module Sdk
    class TestMailer < ActionMailer::Base
      layout nil

      def deliverable(options = {})
        headers(options.delete(:headers).merge({
          "X-MAILER": self.class.name.split('::').last.underscore,
          "X-TEMPLATE": "welcome"
        }))

        mail(options)
      end
    end

    class AccountMailer < TestMailer; end

    class MailerTest < ActiveSupport::TestCase
      def setup
        @client_options = {}
        @mailer = Mailer.new(@client_options)
        Koodeyo::Sdk.add_action_mailer_delivery_method(:koodeyo, @client_options)
      end

      def sample_message(mailer_klass = TestMailer)
        mailer_klass.deliverable(
          delivery_method: :koodeyo,
          body: JSON.dump({ name: "paul" }),
          from: 'Sender <sender@example.com>',
          subject: 'This is a test',
          to: 'Recipient <recipient@example.com>',
          cc: 'Recipient CC <recipient_cc@example.com>',
          bcc: 'Recipient BCC <recipient_bcc@example.com>',
          headers: {}
        )
      end

      test "should deliver the message" do
        response = @mailer.deliver!(sample_message(AccountMailer))
        assert response.success?
        assert_equal(200, response.status)
      end

      test "should not deliver the message when mailer is not support/not found" do
        response = @mailer.deliver!(sample_message)
        refute response.success?
        assert_equal(422, response.status)
      end
    end
  end
end
