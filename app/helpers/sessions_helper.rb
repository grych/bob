module SessionsHelper
  def current_user
    begin # if user is in a session, and does not exists
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound => e
      logger.debug "* Current user not found! #{e.message}"
      session.delete(:user_id)
      redirect_to root_url
    end
  end

  def admin_user?
    current_user.admin if current_user
  end

  def signed_in? 
    !current_user.nil?
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def current_user_img
    current_user.image_url
  end
end
