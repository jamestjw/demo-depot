class ApplicationController < ActionController::Base
    before_action :authorize
    before_action :set_i18n_locale_from_params
    
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

        def set_i18n_locale_from_params
            if params[:locale]
              if I18n.available_locales.map(&:to_s).include?(params[:locale])
                I18n.locale = params[:locale]
              else
                flash.now[:notice] = 
                  "#{params[:locale]} translation not available"
                logger.error flash.now[:notice]
              end
            end
        end
end
