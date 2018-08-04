require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      use ::WineBouncer::OAuth2

      mount API::V1::Users
      mount API::V1::Transactions

      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
