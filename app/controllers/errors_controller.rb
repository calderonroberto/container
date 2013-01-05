class ErrorsController < ApplicationController
  def routing
   render :file => "#{Rails.root}/public/404", :status => 404, :layout => false
  end
end
