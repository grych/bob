class NewsItemsController < ApplicationController
  def feed
    @title = BoB::Application.config.book_title
    @news_items = NewsItem.ordered
    @updated = @news_items.first.updated_at unless @news_items.empty?
    respond_to do |format|
      format.atom { render layout: false }
      format.rss  { redirect_to feed_path(format: :atom), status: :moved_permanently }
    end
  end
end
