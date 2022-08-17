require 'pry'
class EventsController < ApplicationController

  get '/events' do
    redirect_if_not_logged_in
    @events = Event.all.filter{|event| event.public}
    @user = User.find(session[:user_id])
    erb :'/events/index'
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
    UserEvent.new(user_id:@user.id,event_id: @event.id)
    @location = Location.find_or_create_by(locale: params[:location][:name])
    if(@location.categories.include?(@category) && @category.locations.include?(@location) && params[:category_name].empty?)
      @category = Category.find(params[:category_id])
      @user.events<< @event
      @event = @user.events.find(@event.id)
      @category = @location.categories.find{|c| c == @category}
      @location = @category.locations.find{|l| l == @location}
      @user.events.find(@event.id).update(category: @category, location: @location)
      @user.save
    elsif !params[:category_name].empty?
      @category = Category.create(name: params[:category_name])
      @user.events << @event
      @event = @user.events.find(@event.id)
      @user.events.find(@event.id).update(category: @category, location: @location)
      @user.save
    else
      puts "After the failed search"
      @category = Category.find(params[:category_id])
      @user.events << @event
      @event = @user.events.find(@event.id)
      @user.events.find(@event.id).update(category: @category, location: @location)
      @user.save
    end
    redirect to "/events/#{@event.id}"
  end

  get '/events/:id' do
    redirect_if_not_logged_in
    @event = Event.find(params[:id])
    @user = current_user(session)
    @can_edit = false
    @can_delete = false
    if(@event.creator == @user.id)
      @can_edit = true
    end
    if(@event.creator == @user.id)
      @can_delete = true
    end
    erb :'events/show', layout: false
  end

  get '/events/:id/edit' do
    redirect_if_not_logged_in
    @event = Event.find(params[:id])
    @categories = Category.all
    erb :'events/edit'
  end

  patch '/events/:id' do
    @event = Event.find(params[:id])
    @event.update(params[:event])
    @location = Location.find_or_create_by(locale: params[:location][:name])
    if(!params[:category_name].empty?)
      puts params[:event]
      @category = Category.find_or_create_by(name:params[:category_name])
      @event.update(location: @location,category:@category, public:params[:public])
    else
      puts params[:event]
      @category = Category.find(params[:category_id].to_i)
      @event.update(location: @location,category:@category, public:params[:public])
    end
    @event.save
    redirect "/events/#{@event.id}"
  end

  post '/events/:id' do
    @user = current_user(session)
    @user.events << Event.find(params[:id])
    @user.save
    redirect '/homepage'
  end

  delete '/events/:id' do
    @event = Event.find(params[:id])
    @user = current_user(session)

    if(!(@event.creator == @user.id))
      @user.events.delete(@event.id)
      @user.save
    elsif @event.creator == @user.id
      @event.destroy
    end

    redirect '/homepage'
  end
end
