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
    #@user = current_user(session)
    #@event = Event.new(event_name: params[:event][:name],time: params[:event][:time],date:params[:event][:date])
    p @event
    @location = Location.find_or_create_by(locale: params[:location][:name])
    if(@location.categories.include?(@category) && @category.locations.include?(@location) && params[:category_name].empty?)
      puts "In here"
      @category = Category.find(params[:category_id])
      @user.events<< @event
      @event = @user.events.find(@event.id)
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
      #@event.location = @location
      #@event.category = @category
      #@location.categories << @category
      #@category.locations << @location
      #@event.user = @user

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
    @location = Location.find_or_create_by(locale: params[:location][:name])
    if(!params[:category_name].empty?)
      puts "New category"
      @category = Category.find_or_create_by(name:params[:category_name])

      #@event.update(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date],category_id: @category.id,public: params[:event][:public])
      @event.update(params[:event])
      @event.update(category:@category)
      @event.update(location: @location)
    else
      @event.update(params[:event])
      @event.update(location: @location)
    end
    #@event.update(event_name:params[:event][:name], time:params[:event][:time],date:params[:event][:date])
    #@event.location.update(locale: params[:location][:name])
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
      puts " here"
      @event.destroy
    end
    puts "None worked"
    #(@user.events.contains)
    #Location.find_by(locale: @event.location.locale).destroy

    redirect '/homepage'
  end
end
