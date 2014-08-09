class HomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout "application"

  def index
  end

  def ajax_autocomplete
    current_search = params[:search]
    anime_results = []
    if !current_search.nil?
        anime_results = Sunspot.search(Anime) do
                             fulltext current_search
                         end
        anime_results = anime_results.results.map{|ele| ele.name}
        puts anime_results
    end
    render :json => anime_results
  end
end
