require 'pry'
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
    puts params
    @user = current_user(session)

    @event = Event.new(params[:event])

    @category = Category.find(params[:category_id])
    @location = Location.find_or_create_by(locale: params[:location][:name])
    if(@location.categories.include?(@category) && @category.locations.include?(@location))
      puts "In here"
      @user.events << @event
      @event = @user.events.find(@event.id)
      p @event
      #binding.pry
      #@event.category = @location.categories.find{|c| c == @category}
      #@event.location = @category.locations.find{|l| l == @location}
      @category = @location.categories.find{|c| c == @category}
      @location = @category.locations.find{|l| l == @location}
      #@event.update(category: @category)
      #@event.update(location: @location)
      #binding.pry
      #@event.save
      @user.events.find(@event.id).update(category: @category, location: @location)
      @user.save
      #@event.save
      #binding.pry
    else
      puts "After the failed search"
      @user.events << @event
      @event = @user.events.find(@event.id)
      @user.events.find(@event.id).update(category: @category, location: @location)
      #@event.location = @location
      #@event.category = @category
      #@location.categories << @category
      #@category.locations << @location

      @user.save
    end

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
