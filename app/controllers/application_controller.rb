class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_user

  include SessionsHelper

  private

    def ensure_user
      unless user_signed_in?  
        user = User.create_guest
        sign_in user
      end
    end
end
