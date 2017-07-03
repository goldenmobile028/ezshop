module Endpoints
  class Users < Grape::API

    resource :users do

      # Users API test
      # /api/v1/users/ping
      # results  'huawan'
      get :ping do
        { :ping => 'huawan' }
      end

      # Signin
      # GET: /api/v1/users/signin
      # parameters:
      #   email:          String *required
      #   password:       String *required
      #   app_type:        Float *required
      #       0:          Consumer App
      #       1:          Store App

      # results:
      #   return user data
      get :signin do
        users = User.where(email: params[:email])
        users.each do |user|
          if user.password == params[:password] and user.user_type >= params[:app_type].to_i
            return {status: 1, data: user.by_json}
          end
        end
        {status: 0, data: {error: 'Cann\'t find your email'}}
      end

      # Signup
      # GET: /api/v1/users/signup
      # parameters:
      #   email:          String *required
      #   password:       String *required
      #   user_type:       String *required

      # results:
      #   return user data
      get :signup do
        user = User.find_by(email: params[:email])
        if user.present?
          {status: 0, data: {error: 'User exists already'}}
        else
          user = User.new(email: params[:email], password: params[:password], user_type: params[:user_type])
          if user.save()
            token = user.generate_token
            p "------------------"
            p token
            user.update_attributes(auth_token: user.generate_token)
            p user.auth_token
            {status: 1, data: user.by_json}
          else
            {status: 0, data: {error: user.errors.messages}}
          end
        end
      end

    end
  end
end
