class LocationsController < ApplicationController

  get '/locations' do
    redirect_if_not_logged_in
    @locations = Location.all
    erb :'locations/index', :layout => false
  end
  
  get '/locations/:id' do
    redirect_if_not_logged_in
    @location = Location.find(params[:id])
    @user = User.find(session[:user_id])
    erb :'/locations/show', :layout => false
  end
end
