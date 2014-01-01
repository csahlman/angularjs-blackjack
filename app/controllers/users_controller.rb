class UsersController < ApplicationController

  def update_name
    current_user.update_attributes(name: params[:name]) 
  end

end