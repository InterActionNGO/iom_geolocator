class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_admin
    authenticate_or_request_with_http_basic("NGO AID MAP") do |name, password|
      name == ENV["AUTH_USER"] && password == ENV["AUTH_PASSWORD"]
    end
  end
end
