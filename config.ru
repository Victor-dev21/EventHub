require_relative './config/environment'
use Rack::MethodOverride
use UsersController
use EventsController
use LocationsController
use CategoriesController
run ApplicationController
