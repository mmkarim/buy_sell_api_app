module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          def current_user
            resource_owner
          end

          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def error_response msg = "Something went wrong."
            error!({error_code: 404, error_message: msg}, 401)
          end

          def sucees_response
            {result: "OK"}
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
