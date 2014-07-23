class SessionsController < ApplicationController
  def create_from_oauth
    logger.debug "* auth: #{env["omniauth.auth"]}"
    @user = User.from_omniauth(env["omniauth.auth"], current_user)
    session[:user_id] = @user.id
    redirect_back_or root_url
  end
  
  def destroy
    session.delete(:user_id)
    redirect_back_or root_url
  end

  def oauth_failure
    logger.debug "* OAUTH_FAILURE"
    #redirect_to(root_url, notice: 'ACCESS DENIED!')
    redirect_back_or root_url
  end
end
