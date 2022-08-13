class LocationsController < ApplicationController

  get '/locations' do
    @locations = Location.all
    erb :'locations/index'
  end

  get '/locations/:id' do
    @location = Location.find(params[:id])
    @user = User.find(session[:user_id])
    erb :'/locations/show'
  end
end
