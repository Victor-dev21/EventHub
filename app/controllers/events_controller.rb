
class EventsController < ApplicationController

  get '/events' do
    redirect_if_not_logged_in
    @events = Event.all
    @user = User.find(session[:user_id])
    erb :'/events/index', layout: :'layouts/events/events_list'
  end


  get '/events/new' do
    redirect_if_not_logged_in
    @user = User.find(session[:user_id])
    @categories = Category.all
    erb :'/events/new'
  end

  post '/events' do
    @event = Event.create(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    @location = Location.find_or_create_by(locale: params[:location][:name])
    @event.location = @location
    if !params[:event][:category].empty?
      @event.category = Category.find_or_create_by(name: params[:event][:category])
    else
      @event.category = Category.find(params[:event][:category_id])
    end
    @user = User.find(session[:user_id])
    @user.events << @event
    @user.save
    redirect to "/events/#{@event.id}"
  end

  get '/events/:id' do
    redirect_if_not_logged_in
    @event = Event.find(params[:id])
    erb :'events/show', layout: false
  end

  get '/events/:id/edit' do
    redirect_if_not_logged_in
    @event = Event.find(params[:id])
    erb :'events/edit'
  end

  patch '/events/:id' do
    @event = Event.find(params[:id])
    @event.update(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    @event.location.update(locale: params[:location][:name])
    @event.save
    redirect "/events/#{@event.id}"
  end

  post '/events/:id' do
    @user = User.find(session[:user_id])
    @user.events << Event.find(params[:id])
    @user.save
    redirect '/homepage'
  end

  delete '/events/:id' do
    @event = Event.find(params[:id])
    #Location.find_by(locale: @event.location.locale).destroy
    @event.destroy
    redirect '/homepage'
  end
end
