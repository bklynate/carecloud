AppointmentServices::Application.routes.draw do
  resources :appointments

  #Api routes
  namespace 'api' do

    # User API

      controller :reservations do
        get 'reservations(/:start_time/:end_time)', :action=>'list'
      end



  end


end
