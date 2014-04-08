class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :set_csrf_cookie_for_ng
  after_action :protect_json

  before_action :ensure_user


  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def protect_json 
    if response.content_type == "application/json" 
      response.body = ")]}',\n" + response.body 
    end
  end

  include SessionsHelper

  protected

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end
  
  private

    def ensure_user
      unless user_signed_in?  
        user = User.create_guest
        sign_in user
      end
    end
end
