class ApplicationController < ActionController::API
  def verify_authentication
    customer = Customer.find_by(access_token: request.headers["ACCESS_TOKEN"])
    
    if customer.nil? || request.headers["ACCESS_TOKEN"].nil?
      render json: {message: 'cliente deve se autenticar'}, status: 401
    end
  end
end