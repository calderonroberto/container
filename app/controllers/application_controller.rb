class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper #checking for sessions
  include StatesHelper #broadcasting states
  include CheckinsHelper #broadcasting an event to thingbroker
end
