class LocationsController < ApplicationController

  get '/locations' do
    redirect to "#{Helper.redirect_if_not_logged_in(session)}"
    @locations = Location.all
    erb :'locations/index'
  end

  get '/locations/:id' do
    redirect to "#{Helper.redirect_if_not_logged_in(session)}"
    @location = Location.find(params[:id])
    @user = User.find(session[:user_id])
    erb :'/locations/show'
  end
end
