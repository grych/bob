# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  comment_id  :integer
#  chapter_id  :integer
#  comment_dom :string(255)
#  text        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :chapter
  has_many   :comments, dependent: :destroy
  belongs_to :comment

  @@markdown=nil
  def html
    unless @@markdown
      renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
      @@markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, 
        fenced_code_blocks: true, superscript: true, underline: true, highlight: true, quote: true)
    end
    @@markdown.render(text).html_safe
  end

  def descendants
    self.comments.order(:created_at)
  end
end
