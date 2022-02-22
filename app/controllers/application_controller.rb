class ApplicationController < ActionController::API
  def verify_authentication
    if current_user.nil? || request.headers["ACCESS_TOKEN"].nil?
      render json: {message: 'cliente deve se autenticar'}, status: 401
    end
  end
  
  def current_user
    Customer.find_by(access_token: request.headers["ACCESS_TOKEN"])
  end
end