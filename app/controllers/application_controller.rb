require './config/environment'
require 'rack-flash'
class ApplicationController <Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    set :session_secret, "EventManager"
  end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in? || User.find_by(id: session[:user_id]).nil?
        redirect "/user/error"
      end
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user(session)
      User.find(session[:user_id])
    end
  end
end
