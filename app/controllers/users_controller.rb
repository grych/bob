class UsersController < ApplicationController
  def allow_notifications
    if current_user
      if params[:notifications_enabled]
        cu = current_user
        cu.allow_notifications = params[:notifications_enabled].to_bool
        cu.save!
      end
    end
  end
end
