class CommentsController < ApplicationController
  def show
    c = Comment.where(chapter: Chapter.find_by(url: params[:chapter_url]),
      comment_dom: params[:comment_id], comment_id: nil).order(:created_at)
            # nil to find a root of all the comments
    logger.debug("*** comment: #{c.count}")
    @chapter_url = params[:chapter_url]
    @comment_dom = params[:comment_id]
    render partial: 'comments', locals: {comments: c}
  end

  def new # edit as well
    if params[:edit_or_reply] == 'reply'
      unless params[:comment_text].blank?
        new_comment = Comment.create(
          chapter: Chapter.find_by(url: params[:chapter_url]),
          comment_dom: params[:comment_dom],
          text: params[:comment_text]
          )
        current_user.comments << new_comment
        unless params[:comment_id].blank?
          parent_comment = Comment.find(params[:comment_id])
          parent_comment.comments << new_comment
          # Send an email to the parent comment user
          CommentNotificationMailer.notify_email(parent_comment.user, new_comment).deliver
        else
          # Send an email to all the admins
          CommentNotificationMailer.admin_email(new_comment).deliver
        end
        @new_comment = new_comment
      end
    elsif params[:edit_or_reply] == 'edit'
      comment = Comment.find(params[:comment_id])
      if admin_user? || comment.user == current_user
        comment.text = params[:comment_text]
        comment.save!
      end
    end
    @chapter_url = params[:chapter_url]
    @comment_dom = params[:comment_dom]
    render partial: 'after_posting'
  end

  def count
    c = Comment.where(chapter: Chapter.find_by(url: params[:chapter_url]),
      comment_dom: params[:comment_id]).count
    render text: c
  end

  def delete
    c = Comment.find(params[:comment_id])
    if admin_user? || c.user == current_user
      c.destroy!
    end
    @chapter_url = params[:chapter_url]
    @comment_dom = params[:comment_dom]
    render partial: 'after_posting'
  end
end
