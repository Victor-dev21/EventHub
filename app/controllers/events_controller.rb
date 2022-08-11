require_relative '../helpers/helper'
class EventsController < ApplicationController

  get '/events' do
    #shows all of the users events
    erb :index
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
    @event = Event.create(event_name: params[:event][:name], time: params[:event][:time])
    @city = City.create(city_name: params[:city][:name])
    @event.city = @city
    @event.save
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
  end





end
