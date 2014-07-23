class CommentNotificationMailer < ActionMailer::Base
  default from: "RubyForAdmins.com <notifications@rubyforadmins.com>"

  def notify_email(user, comment)
    @user = user
    @comment  = comment
    @url = "http://RubyForAdmins.com/#{if @comment.chapter then @comment.chapter.url end}"
    mail(to: @user.email, subject: 'New Comment on RubyForAdmins.com') if user.allow_notifications
  end

  def admin_email(comment)
    User.where(admin: true).each do |admin|
      @user = admin
      @comment  = comment
      @url = "http://RubyForAdmins.com/#{if @comment.chapter then @comment.chapter.url end}"
      mail(to: @user.email, subject: '[ADMIN] New Comment on RubyForAdmins.com') if admin.allow_notifications
    end
  end
end
