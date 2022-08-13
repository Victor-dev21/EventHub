
class EventsController < ApplicationController

  get '/events' do
    #shows all of the users events
    #@user = User.find(session[:user_id]).events
    redirect_if_not_logged_in
    @events = Event.all
    @user = User.find(session[:user_id])
    erb :'/events/index'
  end


  get '/events/new' do
    #redirect to "#{Helper.redirect_if_not_logged_in(session)}"
    @user = User.find(session[:user_id])
    erb :'/events/new'
  end

  post '/events' do
    puts params
    @event = Event.create(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    @location = Location.find_or_create_by(locale: params[:location][:name])
    @event.location = @location
    @user = User.find(session[:user_id])
    @user.events << @event
    @user.save
    redirect to "/events/#{@event.id}"
  end

  get '/events/:id' do
    #redirect to "#{Helper.redirect_if_not_logged_in(session)}"
    @event = Event.find(params[:id])
    erb :'events/show'
  end

  get '/events/:id/edit' do
    #redirect to "#{Helper.redirect_if_not_logged_in(session)}"
    @event = Event.find(params[:id])
    erb :'events/edit'
  end

  patch '/events/:id' do
    puts params
    @event = Event.find(params[:id])
    @event.update(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    @event.location.update(locale: params[:location][:name])
    @event.save
    redirect "/events/#{@event.id}"
  end
  ##adds an event to the users list
  post '/events/:id' do
    @user = User.find(session[:user_id])
    @user.events << Event.find(params[:id])
    @user.save
    redirect '/homepage'
  end


  delete '/events/:id' do
    @event = Event.find(params[:id])
    Location.find_by(locale: @event.location.locale).destroy
    @event.destroy
    redirect '/homepage'
  end
end
