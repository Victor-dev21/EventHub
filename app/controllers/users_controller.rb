class UsersController < ApplicationController

  get '/' do
    erb :'users/index', :layout => false
  end

  get '/signup' do
    erb :'users/signup', :layout => false
  end

  post '/signup' do
    @user = User.new(name: params[:name],username: params[:username],password: params[:password])
    if(@user.save)
      redirect to '/login'
    else
      puts "HErE"
      redirect to '/signup'
    end
  end

  get '/login' do
    erb :'users/login', :layout => false
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if(@user && @user.authenticate(params[:password]))
      @session = session
      session[:user_id] = @user.id
      redirect to '/homepage'
    else
      redirect '/signup'
    end
  end

  get '/homepage' do
    redirect_if_not_logged_in
    @user = User.find(session[:user_id])
    erb :'users/homepage'
  end

  get '/user/error' do
    erb :'users/error', :layout => false
  end

  get '/logout' do
    redirect_if_not_logged_in
    session.clear
    redirect to '/'
  end
end
