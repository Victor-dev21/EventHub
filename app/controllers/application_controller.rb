class ApplicationController <Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "eventhub"
  end
end

helpers do
def redirect_if_not_logged_in(session)
  if !logged_in?(session)
    redirect to "/login"
  end
end

def logged_in?(session)
  !!session[:user_id]
end

def current_user(session)
  User.find(session[:user_id])
end
end
