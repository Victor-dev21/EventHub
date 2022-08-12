class UsersController < ApplicationController

  get '/' do
    erb :'users/index'
  end

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    @user = User.new(name: params[:name],username: params[:username],password: params[:password])
    p params
    if(@user.save)
      redirect to '/login'
    else
      puts "HErE"
      redirect to '/signup'
    end
  end

  get '/login' do
    erb :'users/login'
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
    @user = User.find(session[:user_id])
    puts @user.events
    erb :'users/homepage'
  end

  get '/user/error' do
    erb :'users/error'
  end

  get '/logout' do
    session.clear
    redirect to '/'
  end
end
