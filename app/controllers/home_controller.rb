class HomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout "application"

  def index
      @game_started = true
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
    render :json => anime_results[0..5]
  end

  def add_op_entry
    title = params[:title]
    music_file = params[:music_file]

    target_anime = Anime.where(:name => title)[0]
    
    if target_anime
      music_entry = Music.new
      music_entry.music_file = music_file
      music_entry.anime = title
      music_entry.save()
      redirect_to "/admin/add_page"
    else
      render :text => "RAWR"
    end
  end

  def submit_answer
    song_id = params[:song_id]
    answer = params[:answer]

    if song_id and answer
        target_music = Music.find(song_id)
        puts target_music.anime
        puts target_music.anime == answer
        if !target_music.nil? and target_music.anime == answer
            render :text => "Correct" and return
        end
    end

    render :text => "Wrong" and return
  end

  def retrieve_answer
    song_id = params[:song_id]

    if song_id
      target_music = Music.find(song_id)
      if !target_music.nil?
        render :text => target_music.anime and return
      end
    end
    render :text => "Undefined" and return
  end
end
