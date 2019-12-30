class ApplicationController < ActionController::Base
    before_action :authorize
    
    protected
        def authorize
            unless User.find_by(id: session[:user_id])
                if !request.format.html? && authenticate_or_request_with_http_basic('Administration') do |username, password|
                        username == 'admin' && password == 'admin'
                    end
                else
                    redirect_to login_url, alert: "You are required to log in to access this functionality."
                end
            end
        end
end
