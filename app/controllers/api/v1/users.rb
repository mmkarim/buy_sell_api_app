module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      resource :users do
        desc "Return user balance"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
        end
        get "/balance" do
          current_user.balances
        end

        desc "Login user"
        params do
          requires :email, type: String, desc: "Email"
          requires :password, type: String, desc: "Password"
        end
        post '/log_in' do
          email = params[:email]
          password = params[:password]

          user = User.find_by(email: email.downcase)

          if user.present? && user.valid_password?(password)
            access_token = Doorkeeper::AccessToken.create(
              resource_owner_id: user.id,
              expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
              scopes: ''
            )

            {
              access_token: access_token.token,
              token_type: 'bearer',
              expires_in: access_token.expires_in,
            }
          else
            error_response "Invalid email or password."
          end
        end

        desc "Register user"
        params do
          requires :name, type: String, desc: "Name"
          requires :currency, type: String, desc: "currency like myr, thb"
          requires :email, type: String, desc: "Email"
          requires :password, type: String, desc: "Password"
        end
        post '/register' do
          user = User.new(
            name: params[:name],
            password: params[:password],
            email: params[:email],
            currency: params[:currency]
          )

          if user.valid?
            user.save
            return user
          else
            error_response "Invalid email or password."
          end
        end
      end
    end
  end
end

