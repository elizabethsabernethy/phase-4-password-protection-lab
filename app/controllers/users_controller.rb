class UsersController < ApplicationController

    before_action :authorize, only: [:show]
    

     def create
    user = User.create(user_params)
    if user.valid?
        session[:user_id] = user.id
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

      def show
        user = User.find_by(id: session[:user_id])
        render json: user
        # if user&.authenticate(params[:password])
        #     session[:user_id] = user.id
        #     render json: user
        #   else
        #     render json: { error: "Invalid username or password" }, status: :unauthorized
        #   end
      end
    
      private
    
      def user_params
        params.permit(:username, :password, :password_confirmation)
      end

      def authorize
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
      end
end
