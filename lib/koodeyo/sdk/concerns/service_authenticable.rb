module Koodeyo
  module Sdk
    module Concerns
      module ServiceAuthenticable
        extend ActiveSupport::Concern

        included do
          attr_reader :service_id, :service_secret, :service_access_token,
          :service_accounts_api, :service_details
        end

        private

        def authenticate_service!
          # Skip
          return if current_service.present?

          @service_id = request.headers['Koodeyo-App-Id']
          @service_secret = request.headers['Koodeyo-App-Secret']

          if service_id.nil? || service_secret.nil?
            return render_error("Missing Authorization headers")
          end

          # get access_token
          @service_access_token = get_access_token

          # get service details
          @service_details = get_service_details

          # Only allow official apps/services
          return render_error("App not failed to authenticate") unless @service_details['is_official']

          save_service
        end

        def get_access_token
          @service_accounts_api ||= Sdk::Accounts.new({
            authorization: {
              grant_type: 'client_credentials',
              client_id: service_id,
              client_secret: service_secret,
              scope: 'read'
            },
            headers: {
              "Skip-Devise-Doorkeeper": "true"
            }
          })

          response = @service_accounts_api.get_access_token
          return unless response.success?

          response.to_json['access_token']
        end

        def get_service_details
          response = service_accounts_api.find_app_by_uid(service_id)
          return unless response.success?

          service_accounts_api.find_app_by_uid(service_id).to_json
        end

        def render_error(message)
          render json: { message: }, status: :unauthorized
        end

        def save_service
          # save :service_id, :service_details
        end

        def current_service
        end
      end
    end
  end
end
