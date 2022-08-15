class LocationsController < ApplicationController

  get '/locations' do
    redirect_if_not_logged_in
    @locations = Location.all
    erb :'locations/index', :layout => false
  end

  get '/locations/:id' do
    redirect_if_not_logged_in
    @location = Location.find(params[:id])
    @events = @location.events
    @user = User.find(session[:user_id])
    @categories = @location.categories
    erb :'/locations/show', layout: :'layouts/events/events_list'
  end

  get '/locations/:id/:category_name' do
    @location = Location.find(params[:id])
    @category = @location.categories
    @user = User.find(session[:user_id])
    @events = Event.all.where(location_id: params[:id],category_id: Category.find_by(name: params[:category_name]).id)
    erb :'locations/events_by_category', layout: :'layouts/events/events_list'
  end
end
