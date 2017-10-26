module Endpoints
  class Users < Grape::API

    resource :users do

      # Users API test
      # /api/v1/users/ping
      # results  'huawan'
      get :ping do
        { :ping => 'huawan' }
      end


      def create_user(email, password, user_type, social)
        user = User.new(email: email.downcase, password: password, user_type: user_type)
        if user.save()
          token = user.generate_token
          user.update_attributes(auth_token: user.generate_token)
          user.update_attributes(social: social)
          p user.auth_token
          {status: 1, data: user.by_json}
        else
          {status: 0, data: {error: user.errors.messages}}
        end
      end


      # Signin
      # GET: /api/v1/users/signin
      # parameters:
      #   email:          String *required
      #   password:       String *required
      #   app_type:       Float *required
      #       0:          Consumer App
      #       1:          Store App

      # results:
      #   return user data
      get :signin do
        users = User.where(email: params[:email].downcase)
        users.each do |user|
          if user.password == params[:password] and user.user_type >= params[:app_type].to_i
            return {status: 1, data: user.by_json}
          end
          return {status: 0, data: {error: 'Password doesn\'t match'}}
        end
        {status: 0, data: {error: 'Can\'t find your email'}}
      end

      # Signin with Facebook
      # GET: /api/v1/users/signin_facebook
      # parameters:
      #   email:          String *required
      #   username:       String *required
      #   app_type:       Float *required
      #       0:          Consumer App
      #       1:          Store App

      # results:
      #   return user data
      get :signin_facebook do
        users = User.where(email: params[:email].downcase)
        password = "fb" + params[:username] + "!"
        users.each do |user|
          # if user.password == password and user.user_type >= params[:app_type].to_i
            return {status: 1, data: user.by_json}
          # end
          return {status: 0, data: {error: 'The user email exists already'}}
        end
        Users.create_user(params[:email].downcase, password, params[:app_type].to_i, "facebook")
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
        user = User.find_by(email: params[:email].downcase)
        if user.present?
          {status: 0, data: {error: 'User exists already'}}
        else
          Users.create_user(params[:email].downcase, params[:password], params[:user_type].to_i, "")
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
        user = User.find_by(email: params[:email].downcase)
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
        users = User.where(email: params[:email].downcase)
        users.each do |user|
          if user.password == params[:old_password]
            user.update_attributes(password: params[:new_password])
            return {status: 1, data: user.by_json}
          end
        end
        {status: 0, data: {error: 'Can\'t find your email'}}
      end

    end
  end
end
