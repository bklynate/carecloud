AppointmentServices::Application.routes.draw do

  resources :appointments

  #Api routes
  namespace 'api' do

      controller :appointments do

        post 'appointments', :action=>:create
        get 'appointments(/:start_time(/:end_time))', :action=>:list
        delete 'appointments/:id', :action=>:destroy
        put 'appointments/:id', :action=>:update

      end
  end


end
