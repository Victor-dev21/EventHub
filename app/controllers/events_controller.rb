require_relative '../helpers/helper'
class EventsController < ApplicationController

  get '/events' do
    #shows all of the users events
    #@user = User.find(session[:user_id]).events
    @events = Event.all
    erb :'/events/index'
  end


  get '/events/new' do
    if !Helper.logged_in?(session)
      puts "here"
      redirect to '/user/error'
    else
      @user = User.find(session[:user_id])
      erb :'/events/new'
    end
  end

  post '/events' do
    puts params
    @event = Event.create(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    @location = Location.create(locale: params[:location][:name])
    @event.location = @location
    @user = User.find(session[:user_id])
    @user.events << @event
    @user.save
    redirect to "/events/#{@event.id}"
  end

  get '/events/:id' do
    @event = Event.find(params[:id])
    erb :'events/show'
  end

  get '/events/:id/edit' do
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

  delete '/events/:id' do
    @event = Event.find(params[:id])
    @event.location.destroy
    @event.destroy
    redirect '/homepage'
  end
end
