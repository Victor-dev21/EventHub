class CategoriesController < ApplicationController

  get '/categories' do
    @categories = Category.all
    erb :'categories/index'
  end

  get '/categories/:id' do
    @category = Category.find(params[:id])
    @events = @category.events
    @user = User.find(session[:user_id])
    erb :'categories/show', layout: :'layouts/events/events_list'
  end
end
