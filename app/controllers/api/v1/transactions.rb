module API
  module V1
    class Transactions < Grape::API
      include API::V1::Defaults

      resource :transactions do
        desc "Return all transactions of user"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
        end
        get "/" do
          current_user.transactions
        end

        desc "Top up"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
          requires :amount, type: Integer, desc: "Amount"
        end
        post "/top_up" do
          amount = params[:amount].try(:to_i)

          ActiveRecord::Base.transaction do
            if current_user.cash.add_amount!(amount)
              current_user.transactions.create! asset: :cash, amount: amount, type: :top_up
              sucees_response
            else
              error_response
            end
          end
        end

        desc "Buy gold"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
          requires :cash_amount, type: Integer, desc: "Amount of cash"
        end
        post "/buy" do
          cash_amount = params[:cash_amount].try(:to_f)
          gold_amount = cash_amount * Balance::CASH_TO_GOLD_RATE

          ActiveRecord::Base.transaction do
            if current_user.cash.deduct_amount!(cash_amount) && current_user.gold.add_amount!(gold_amount)
              current_user.transactions.create! asset: :gold, amount: cash_amount, type: :buy
              sucees_response
            else
              error_response
            end
          end
        end

        desc "Sell gold"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
          requires :gold_amount, type: Integer, desc: "Amount of gold"
        end
        post "/sell" do
          gold_amount = params[:gold_amount].try(:to_f)
          cash_amount = gold_amount * Balance::GOLD_TO_CASH_RATE

          ActiveRecord::Base.transaction do
            if current_user.gold.deduct_amount!(gold_amount) && current_user.cash.add_amount!(cash_amount)
              current_user.transactions.create! asset: :gold, amount: cash_amount, type: :sell
              sucees_response
            else
              error_response
            end
          end
        end

        desc "Withdraw"
        oauth2
        params do
          requires :access_token, type: String, desc: "Authorization"
          requires :cash_amount, type: Integer, desc: "Withdraw amount of cash"
        end
        post "/withdraw" do
          cash_amount = params[:cash_amount].try(:to_f)

          ActiveRecord::Base.transaction do
            if current_user.cash.deduct_amount!(cash_amount)
              # Proecedure for withdrawing money to user
              current_user.transactions.create! asset: :cash, amount: cash_amount, type: :withdraw
              sucees_response
            else
              error_response
            end
          end
        end
      end
    end
  end
end

