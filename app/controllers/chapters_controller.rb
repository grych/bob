class ChaptersController < ApplicationController

  def index
    @chapter = Chapter.root
    render_chapter
  end

  def show
    @chapter = Chapter.find_by(url: params[:chapter_url])
    raise ActionController::RoutingError.new("No route matches [GET] \"#{params[:chapter_url]}\"") unless @chapter
    session[:last_read] = @chapter
    store_location
    render_chapter
  end

  def ok_with_cookies
    session[:ok_with_cookies] = true
    render json: {ok: true}
  end

  def save_bob_view
    session[:view] = params[:bob_view].to_sym
    render json: {ok: true}
  end

  private
  def render_chapter
    render template: 'layouts/chapter'
  end
end
