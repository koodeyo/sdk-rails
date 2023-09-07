module Koodeyo
  module Sdk
    class Railtie < ::Rails::Railtie
      initializer 'koodeyo-sdk.initialize', before: :load_config_initializers do
        Koodeyo::Sdk.add_action_mailer_delivery_method
      end
    end

    # @param [Symbol] name The name of the ActionMailer delivery method to register.
    # @param [Hash] client_options The options you wish to pass on to the mailer lib
    def self.add_action_mailer_delivery_method(name = :koodeyo, client_options = {})
      ActiveSupport.on_load(:action_mailer) do
        add_delivery_method(name, Koodeyo::Sdk::Mailer, client_options)
      end
    end
  end
end
