module Endpoints
  class Stores < Grape::API

    resource :stores do

      # Stores API test
      # /api/v1/stores/ping
      # results  'huawan'
      get :ping do
        { :ping => 'huawan' }
      end

      # GetStore
      # GET: /api/v1/stores/get_store
      # parameters:
      #   email:          String *required

      # results:
      #   return stores list
      get :get_store do
        store = Store.find_by(email: params[:email])
        if store.present?
          {status: 1, data: store.by_json}
        else
          {status: 0, data: {error: 'Cann\'t find your store'}}
        end
      end

      # Create Store
      # GET: /api/v1/stores/create_store
      # parameters:
      #   email:          String *required
      #   name:           String *required
      #   address:        String *required
      #   city:           String *required
      #   zip:            String *required
      #   longitude:      Float *required
      #   latitude:       Float *required

      # results:
      #   return store data
      get :create_store do
        store = Store.find_by(email: params[:email])
        if store.present?
          {status: 0, data: {error: 'Store exists already'}}
        else
          p params[:latitude]
          store = Store.new(email: params[:email], name: params[:name], address: params[:address],
                            city: params[:city], zip: params[:zip], longitude: params[:longitude],
                            latitude: params[:latitude])
          if store.save()
            {status: 1, data: store.by_json}
          else
            {status: 0, data: {error: store.errors.messages}}
          end
        end
      end
    end
  end
end
