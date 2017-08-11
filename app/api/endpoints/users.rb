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
          {status: 0, data: {error: 'Password doesn\'t match'}}
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
            user.update_attributes(auth_token: user.generate_token)
            p user.auth_token
            {status: 1, data: user.by_json}
          else
            {status: 0, data: {error: user.errors.messages}}
          end
        end
      end


      # Reset Password
      # POST: /api/v1/users/reset_password
      # parameters:
      #   email:          String *required
      #   user_type:       String *required

      # results:
      #   return status
      post :reset_password do
        user = User.find_by(email: params[:email])
        if user.present?
          password = user.generate_password
          user.update_attributes(password: user.generate_password)
          # send email
          UserMailer.reset_password_email(user).deliver
          {status: 1, data: user.by_json}
        else
          {status: 0, data: {error: 'User does not exist'}}
        end
      end


      # Change Password
      # GET: /api/v1/users/change_password
      # parameters:
      #   email:          String *required
      #   old_password:   String *required
      #   new_password:   String *required
      #   user_type:      String *required

      # results:
      #   return status
      get :change_password do
        users = User.where(email: params[:email])
        users.each do |user|
          if user.password == params[:old_password]
            user.update_attributes(password: params[:new_password])
            return {status: 1, data: user.by_json}
          end
        end
        {status: 0, data: {error: 'Cann\'t find your email'}}
      end

    end
  end
end
