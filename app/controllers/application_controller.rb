class ApplicationController < ActionController::Base
    helper_method :logged_in?, :current_user

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login!(user)
        session[:session_token] = user.reset_session_token!
    end

    def logged_in?
        !!current_user
    end

    def logout!
        @current_user.reset_session_token! if logged_in?
        session[:session_token] = nil
        @current_user = nil
    end

    def require_login 
        redirect new_session_url if !logged_in?
    end
end
